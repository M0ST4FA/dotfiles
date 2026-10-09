import signal,fcntl,os,pathlib,pty,select,shlex,struct,subprocess,tempfile,termios,time,unittest
REPO=pathlib.Path(__file__).resolve().parents[1]
class FetchTests(unittest.TestCase):
 def test_control_s_fetches_and_displays_new_mail(self):
  if not pathlib.Path('/usr/bin/neomutt').exists():self.skipTest('neomutt unavailable')
  config=(REPO/'stow/neomutt/.config/neomutt/neomuttrc').read_text()
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary);mail=root/'mail';bin_dir=root/'.local/bin';bin_dir.mkdir(parents=True)
   for part in ('cur','new','tmp'):(mail/part).mkdir(parents=True)
   (mail/'cur/old:2,S').write_text('From: old@example.com\nSubject: OLD MESSAGE\n\nold\n')
   command=bin_dir/'mail-sync';command.write_text('#!/bin/sh\nprintf "%s\\n" "$@" > '+shlex.quote(str(root/'arguments'))+'\ncat > '+shlex.quote(str(mail/'new/fetched'))+' <<\'MAIL\'\nFrom: sender@example.com\nSubject: NEW OTP\n\nfixture code\nMAIL\n');command.chmod(0o755)
   rc=root/'neomuttrc';rc.write_text('set folder="'+str(mail)+'"\nset quit=yes\nset sort=date\nset wait_key=no\n'+ '\n'.join(line for line in config.splitlines() if line.startswith(r'macro index,pager \cs'))+'\n')
   master,slave=pty.openpty();attrs=termios.tcgetattr(slave);attrs[0]|=termios.IXON;termios.tcsetattr(slave,termios.TCSANOW,attrs);fcntl.ioctl(slave,termios.TIOCSWINSZ,struct.pack('HHHH',40,120,0,0))
   worker=subprocess.Popen([str(REPO/'stow/neomutt/.local/bin/neomutt'),'-n','-F',str(rc),'-f',str(mail)],stdin=slave,stdout=slave,stderr=slave,env=dict(os.environ,HOME=str(root),XDG_STATE_HOME=str(root/'state'),PATH='/usr/bin:/bin',TERM='xterm',LANG='C.UTF-8',LINES='40',COLUMNS='120',SHELL='/bin/sh'),start_new_session=True)
   def read_until(text):
    result=b'';deadline=time.monotonic()+3
    while text not in result and time.monotonic()<deadline:
     if select.select([master],[],[],.1)[0]:
      try:result+=os.read(master,65536)
      except OSError:break
    return result
   try:
    initial=read_until(b'OLD MESSAGE');time.sleep(1.1);os.write(master,b'\x13');screen=read_until(b'NEW OTP')
    self.assertTrue((root/'arguments').exists(),repr(initial+screen))
    self.assertEqual((root/'arguments').read_text().split(),[])
    self.assertIn(b'NEW OTP',screen,'Fetched mail must appear without reopening the mailbox')
    os.write(master,b'q');worker.wait(timeout=5)
    self.assertTrue(termios.tcgetattr(slave)[0]&termios.IXON,'The launcher must restore terminal flow control on exit')
   finally:
    if worker.poll() is None:os.killpg(worker.pid,signal.SIGKILL)
    worker.communicate(timeout=5);os.close(master);os.close(slave)
if __name__=='__main__':unittest.main()
