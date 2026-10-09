import os, pathlib, subprocess, tempfile, unittest, tomllib

SCRIPT = pathlib.Path(__file__).resolve().parents[1]/'stow/noctalia/.local/bin/noctalia-dotfiles'
class NoctaliaTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup); self.root=pathlib.Path(self.tmp.name)
  self.config=self.root/'config/noctalia'; self.config.mkdir(parents=True)
  self.state=self.root/'state/noctalia'; self.state.mkdir(parents=True)
  self.base=self.root/'base.toml'; self.base.write_text('[theme]\nmode="dark"\n')
  (self.config/'config.toml').symlink_to(self.base)
  (self.state/'settings.toml').write_text('config_version=8\n[wallpaper]\nlast="old"\npath="new"\n[theme]\nmode="light"\n')
  (self.state/'state.toml').write_text('private=true\n')
  self.bin=self.root/'bin'; self.bin.mkdir()
  mock=self.bin/'noctalia'; mock.write_text('#!/bin/sh\nif [ "$2" = export ]; then\n printf \'config_version=8\\n[wallpaper]\\nlast="old"\\npath="new"\\n[theme]\\nmode="light"\\n\'\nelse\n exit "${VALIDATE_FAIL:-0}"\nfi\n'); mock.chmod(0o755)
  self.env=dict(os.environ,XDG_CONFIG_HOME=str(self.root/'config'),XDG_STATE_HOME=str(self.root/'state'),PATH=str(self.bin)+':'+os.environ['PATH'])
 def run_tool(self,command):
  self.assertTrue(SCRIPT.exists(),'Noctalia ownership tool has not been implemented')
  return subprocess.run([str(SCRIPT),command],env=self.env,capture_output=True,text=True)
 def test_capture_filters_runtime_fields_and_preserves_link(self):
  result=self.run_tool('capture'); self.assertEqual(result.returncode,0,result.stderr)
  self.assertTrue((self.config/'config.toml').is_symlink()); data=tomllib.loads(self.base.read_text())
  self.assertNotIn('config_version',data); self.assertNotIn('last',data['wallpaper']); self.assertEqual(data['theme']['mode'],'light')
  self.assertTrue(list((self.root/'state/noctalia-dotfiles/backups').iterdir()))
 def test_invalid_capture_leaves_base_and_link_unchanged(self):
  self.env['VALIDATE_FAIL']='1'; original=self.base.read_bytes()
  self.assertNotEqual(self.run_tool('capture').returncode,0); self.assertEqual(self.base.read_bytes(),original); self.assertTrue((self.config/'config.toml').is_symlink())
 def test_reset_keeps_runtime_fields_and_other_state(self):
  result=self.run_tool('reset-overrides'); self.assertEqual(result.returncode,0,result.stderr)
  self.assertEqual(tomllib.loads((self.state/'settings.toml').read_text()),{'config_version':8,'wallpaper':{'last':'old'}})
  self.assertEqual((self.state/'state.toml').read_text(),'private=true\n')
if __name__=='__main__': unittest.main()
