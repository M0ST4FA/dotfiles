import os,pathlib,socket,subprocess,tempfile,unittest
SCRIPT=pathlib.Path(__file__).resolve().parents[1]/'stow/neomutt/.local/bin/mail-session'
class SessionTests(unittest.TestCase):
 def test_session_stays_active_until_wayland_disconnects(self):
  self.assertTrue(SCRIPT.exists(),'Wayland session bridge is missing')
  with tempfile.TemporaryDirectory() as temporary:
   address=str(pathlib.Path(temporary)/'wayland-test')
   with socket.socket(socket.AF_UNIX,socket.SOCK_STREAM) as server:
    server.bind(address);server.listen();server.settimeout(5)
    worker=subprocess.Popen([str(SCRIPT)],env=dict(os.environ,WAYLAND_DISPLAY=address),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    try:
     client,_=server.accept();self.assertIsNone(worker.poll());client.close();worker.communicate(timeout=5);self.assertEqual(worker.returncode,0)
    finally:
     if worker.poll() is None:worker.kill();worker.communicate()
if __name__=='__main__':unittest.main()
