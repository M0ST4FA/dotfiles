import fcntl,importlib.machinery,importlib.util,os,pathlib,subprocess,tempfile,time,unittest
BIN=pathlib.Path(__file__).resolve().parents[1]/'stow/neomutt/.local/bin'
class BootstrapTests(unittest.TestCase):
 def load(self):
  script=BIN/'mail-bootstrap';self.assertTrue(script.exists(),'Safe bootstrap tool is missing')
  loader=importlib.machinery.SourceFileLoader('bootstrap',str(script));spec=importlib.util.spec_from_loader(loader.name,loader);module=importlib.util.module_from_spec(spec);loader.exec_module(module);return module
 def test_launcher_waits_for_mailbox_promotion(self):
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary);state=root/'mail-sync';state.mkdir();lock=(state/'view.lock').open('a');fcntl.flock(lock,fcntl.LOCK_EX)
   worker=subprocess.Popen([str(BIN/'neomutt'),'-n','-F','/dev/null','-Q','weed'],env=dict(os.environ,XDG_STATE_HOME=temporary,TERM='xterm'),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
   try:
    time.sleep(.15);self.assertIsNone(worker.poll(),'The launcher must wait until migration and indexing finish')
    fcntl.flock(lock,fcntl.LOCK_UN);worker.communicate(timeout=5);self.assertEqual(worker.returncode,0)
   finally:
    lock.close()
    if worker.poll() is None:worker.kill()
    worker.communicate()
 def test_promotion_indexes_before_unlocking_and_retains_backup(self):
  module=self.load()
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary);live=root/'live';stage=root/'stage';live.mkdir();stage.mkdir();(live/'old').write_text('old');(stage/'new').write_text('new');backup=root/'backup'
   called=[]
   module.promote(stage,live,backup,lambda:called.append((live/'new').read_text()))
   self.assertEqual(called,['new']);self.assertEqual((backup/'old').read_text(),'old')
 def test_bootstrap_rejects_native_unsynchronized_local_edits(self):
  module=self.load()
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary)
   for side in ('far','near'):
    for part in ('cur','new','tmp'):(root/side/'INBOX'/part).mkdir(parents=True)
   (root/'far/INBOX/new/remote').write_text('Message-ID: <remote@fixture>\n\nfixture\n')
   config=root/'mbsyncrc';config.write_text(f'Sync New Gone Flags\nSyncState *\n\nMaildirStore far\nPath {root}/far/\nInbox {root}/far/INBOX\n\nMaildirStore near\nPath {root}/near/\nInbox {root}/near/INBOX\n\nChannel test\nFar :far:\nNear :near:\nPatterns INBOX\n')
   result=subprocess.run(['mbsync','-c',str(config),'test'],capture_output=True,text=True);self.assertEqual(result.returncode,0,result.stderr)
   module.verify_clean(root/'near')
   local=root/'near/INBOX/new/local';local.write_text('unsent draft')
   with self.assertRaisesRegex(ValueError,'unsynchronized'):module.verify_clean(root/'near')
   local.unlink();message=next((root/'near/INBOX/new').iterdir());changed=message.with_name(message.name.split(':2,')[0]+':2,FS');message.rename(changed)
   with self.assertRaisesRegex(ValueError,'unsynchronized'):module.verify_clean(root/'near')
   changed.unlink()
   with self.assertRaisesRegex(ValueError,'deletion'):module.verify_clean(root/'near')
 def test_failed_index_rolls_back_the_live_mailbox(self):
  module=self.load()
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary);live=root/'live';stage=root/'stage';live.mkdir();stage.mkdir();(live/'old').write_text('old');(stage/'new').write_text('new')
   def fail():raise RuntimeError('index failed')
   with self.assertRaises(RuntimeError):module.promote(stage,live,root/'backup',fail)
   self.assertEqual((live/'old').read_text(),'old');self.assertEqual((stage/'new').read_text(),'new')
if __name__=='__main__':unittest.main()
