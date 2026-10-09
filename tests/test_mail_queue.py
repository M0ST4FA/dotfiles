import fcntl, json, os, pathlib, subprocess, tempfile, time, unittest
BIN=pathlib.Path(__file__).resolve().parents[1]/'stow/neomutt/.local/bin'
MESSAGE=b'From: infra@nerdio.app\nTo: visible@example.com\nSubject: Queue test\n\nbody\n'
class QueueTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup); self.root=pathlib.Path(self.tmp.name)
  self.mock=self.root/'bin'; self.mock.mkdir()
  for name,body in {'systemctl':'exit 0','msmtp':'''exec python3 -c 'import json,os,sys,time; from pathlib import Path; p=Path(os.environ["SMTP_LOG"]); p.open("a").write(json.dumps(sys.argv[1:])+"\\n"); time.sleep(float(os.getenv("SMTP_DELAY","0"))); sys.stdin.buffer.read(); sys.exit(int(os.getenv("SMTP_FAIL","0")))' "$@"'''} .items():
   p=self.mock/name; p.write_text('#!/bin/sh\n'+body+'\n'); p.chmod(0o755)
  self.env=dict(os.environ,HOME=str(self.root),XDG_STATE_HOME=str(self.root/'state'),XDG_DATA_HOME=str(self.root/'data'),PATH=str(self.mock)+':'+os.environ['PATH'],SMTP_LOG=str(self.root/'smtp.log'))
 def run_cmd(self,cmd,*args,input=None):
  self.assertTrue((BIN/cmd).exists(),'Mail queue commands have not been implemented')
  return subprocess.run([str(BIN/cmd),*args],env=self.env,input=input,capture_output=True)
 def submit(self,account='nerdio-infra'):
  result=self.run_cmd('mail-submit',account,'-f','infra@nerdio.app','--','visible@example.com','hidden@example.com',input=MESSAGE)
  self.assertEqual(result.returncode,0,result.stderr)
 def jobs(self,state='new',account='nerdio-infra'):
  return list((self.root/f'state/mail-queue/{account}/{state}').glob('*'))
 def test_submission_is_private_and_quick_preserving_bcc_arguments(self):
  self.env['SMTP_DELAY']='3'; start=time.monotonic(); self.submit(); self.assertLess(time.monotonic()-start,1)
  job=self.jobs()[0]; self.assertEqual((job/'message').read_bytes(),MESSAGE); self.assertEqual(json.loads((job/'arguments.json').read_text())[-1],'hidden@example.com'); self.assertEqual(job.stat().st_mode&0o777,0o700)
 def test_failure_retries_then_creates_one_sent_copy(self):
  self.submit(); self.env['SMTP_FAIL']='1'; self.assertNotEqual(self.run_cmd('mail-queue-flush').returncode,0); self.assertEqual(len(self.jobs()),1)
  self.env['SMTP_FAIL']='0'; self.assertEqual(self.run_cmd('mail-queue-flush').returncode,0); self.assertFalse(self.jobs()); sent=list((self.root/'data/mail/nerdio-infra/Sent/cur').glob('*')); self.assertEqual(len(sent),1); self.assertEqual(sent[0].read_bytes(),MESSAGE)
  self.run_cmd('mail-queue-flush'); self.assertEqual(len((self.root/'smtp.log').read_text().splitlines()),2)
 def test_gmail_does_not_create_sent_copy(self):
  self.submit('gmail-mostafa'); self.assertEqual(self.run_cmd('mail-queue-flush').returncode,0); self.assertFalse((self.root/'data/mail/gmail-mostafa/Sent').exists())
 def test_interrupted_delivery_is_held_until_explicit_retry(self):
  self.submit(); job=self.jobs()[0]; sending=job.parent.parent/'sending'; sending.mkdir(exist_ok=True); job.rename(sending/job.name)
  self.run_cmd('mail-queue-flush'); self.assertEqual(len(self.jobs('held')),1); self.assertFalse((self.root/'smtp.log').exists())
  status=self.run_cmd('mail-queue','status'); self.assertIn(b'held',status.stdout)
  self.assertEqual(self.run_cmd('mail-queue','retry','nerdio-infra').returncode,0); self.assertEqual(len(self.jobs()),1)
  self.assertEqual(self.run_cmd('mail-queue-flush').returncode,0)
 def test_concurrent_workers_deliver_once(self):
  self.submit(); self.env['SMTP_DELAY']='0.4'
  first=subprocess.Popen([str(BIN/'mail-queue-flush')],env=self.env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
  time.sleep(.1); second=self.run_cmd('mail-queue-flush'); first.communicate(timeout=5)
  self.assertEqual(first.returncode,0); self.assertEqual(len((self.root/'smtp.log').read_text().splitlines()),1)
 def test_confirmed_delivery_recovers_sent_copy_without_resending(self):
  self.submit(); job=self.jobs()[0]; delivered=job.parent.parent/'delivered'; delivered.mkdir(exist_ok=True); job.rename(delivered/job.name)
  self.assertEqual(self.run_cmd('mail-queue-flush').returncode,0); self.assertFalse((self.root/'smtp.log').exists()); self.assertEqual(len(list((self.root/'data/mail/nerdio-infra/Sent/cur').glob('*'))),1)
 def test_sent_copy_waits_until_mailbox_promotion_finishes(self):
  self.submit(); session=self.root/'state/mail-sync';session.mkdir()
  with (session/'view.lock').open('a') as lock:
   fcntl.flock(lock,fcntl.LOCK_EX)
   worker=subprocess.Popen([str(BIN/'mail-queue-flush')],env=self.env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
   try:
    time.sleep(.15);self.assertIsNone(worker.poll(),'Sent copies must not race a mailbox promotion')
    fcntl.flock(lock,fcntl.LOCK_UN);worker.communicate(timeout=5);self.assertEqual(worker.returncode,0)
   finally:
    if worker.poll() is None:worker.kill()
    worker.communicate()
 def test_recovery_recognizes_mbsync_renamed_sent_copy(self):
  self.submit();job=self.jobs()[0];delivered=job.parent.parent/'delivered';job=job.rename(delivered/job.name)
  sent=self.root/'data/mail/nerdio-infra/Sent/cur';sent.mkdir(parents=True)
  (sent/(job.name+',U=42:2,FS')).write_bytes(MESSAGE)
  self.assertEqual(self.run_cmd('mail-queue-flush').returncode,0)
  self.assertEqual(len(list(sent.iterdir())),1);self.assertFalse((self.root/'smtp.log').exists())
 def test_worker_does_not_overlap_native_sync(self):
  self.submit();session=self.root/'state/mail-sync';session.mkdir()
  with (session/'lock').open('a') as lock:
   fcntl.flock(lock,fcntl.LOCK_EX)
   self.assertEqual(self.run_cmd('mail-queue-flush').returncode,0)
   self.assertFalse((self.root/'smtp.log').exists());self.assertEqual(len(self.jobs()),1)
 def test_worker_accepts_inherited_sync_lock_without_deadlock(self):
  self.submit();session=self.root/'state/mail-sync';session.mkdir()
  with (session/'lock').open('a') as lock:
   fcntl.flock(lock,fcntl.LOCK_EX)
   result=subprocess.run([str(BIN/'mail-queue-flush'),'nerdio-infra'],env=dict(self.env,MAIL_SYNC_LOCK_FD=str(lock.fileno())),pass_fds=(lock.fileno(),),capture_output=True,timeout=5)
   self.assertEqual(result.returncode,0,result.stderr)
   self.assertEqual(len((self.root/'smtp.log').read_text().splitlines()),1)
 def test_unknown_account_does_not_queue(self):
  self.assertNotEqual(self.run_cmd('mail-submit','bad',input=MESSAGE).returncode,0); self.assertFalse(self.jobs())
if __name__=='__main__': unittest.main()
