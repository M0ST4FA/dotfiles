import os,pathlib,subprocess,tempfile,unittest
BIN=pathlib.Path(__file__).resolve().parents[1]/'stow/neomutt/.local/bin'
class HelpersTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup); root=pathlib.Path(self.tmp.name); self.root=root; self.mock=root/'bin'; self.mock.mkdir()
  p=self.mock/'secret-tool'; p.write_text('#!/bin/sh\nprintf "test-secret\\n"\n'); p.chmod(0o755)
  self.env=dict(os.environ,HOME=str(root),XDG_STATE_HOME=str(root/'state'),PATH=str(self.mock)+':'+os.environ['PATH'],SYNC_LOG=str(root/'sync.log'))
 def test_password_only_and_original_interface(self):
  args=['--username','test@example.com','--hostname','imap.example.com','--type','imaps']
  result=subprocess.run([str(BIN/'neomutt-credentials'),'--password-only',*args],env=self.env,capture_output=True,text=True)
  self.assertEqual(result.returncode,0,result.stderr); self.assertEqual(result.stdout,'test-secret\n')
  result=subprocess.run([str(BIN/'neomutt-credentials'),*args],env=self.env,capture_output=True,text=True)
  self.assertEqual(result.stdout,'username: test@example.com\npassword: test-secret\n')
 def test_sync_receives_and_indexes_despite_delivery_failure(self):
  self.assertTrue((BIN/'mail-sync').exists(),'mail-sync is missing')
  for name,rc in [('mail-queue-flush',1),('mail-mirror-config',0),('mbsync',1),('notmuch',0)]:
   p=self.mock/name; p.write_text(f'#!/bin/sh\nprintf "{name}\\n" >> "$SYNC_LOG"\nexit {rc}\n'); p.chmod(0o755)
  result=subprocess.run([str(BIN/'mail-sync')],env=self.env,capture_output=True,text=True)
  self.assertNotEqual(result.returncode,0); self.assertEqual((self.root/'sync.log').read_text().splitlines(),['mail-mirror-config','mbsync']*4+['notmuch','mail-queue-flush'])
if __name__=='__main__': unittest.main()
