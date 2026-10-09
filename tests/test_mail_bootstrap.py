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
 def test_failed_index_rolls_back_the_live_mailbox(self):
  module=self.load()
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary);live=root/'live';stage=root/'stage';live.mkdir();stage.mkdir();(live/'old').write_text('old');(stage/'new').write_text('new')
   def fail():raise RuntimeError('index failed')
   with self.assertRaises(RuntimeError):module.promote(stage,live,root/'backup',fail)
   self.assertEqual((live/'old').read_text(),'old');self.assertEqual((stage/'new').read_text(),'new')
if __name__=='__main__':unittest.main()
