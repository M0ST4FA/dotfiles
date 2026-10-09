import fcntl,os,pathlib,pty,select,struct,subprocess,tempfile,termios,time,unittest
REPO=pathlib.Path(__file__).resolve().parents[1]
class HeaderTests(unittest.TestCase):
 def test_normal_pager_shows_only_the_five_selected_headers(self):
  if not pathlib.Path('/usr/bin/neomutt').exists():self.skipTest('neomutt unavailable')
  config=(REPO/'stow/neomutt/.config/neomutt/neomuttrc').read_text()
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary); mail=root/'mail'
   for part in ('cur','new','tmp'):(mail/part).mkdir(parents=True)
   (mail/'cur/1:2,S').write_text('From: sender@example.com\nTo: recipient@example.com\nCc: copy@example.com\nDate: Fri, 9 Oct 2026 12:00:00 +0200\nSubject: FILTER SUBJECT\nOrganization: HIDDEN ORGANIZATION\nUser-Agent: HIDDEN USER AGENT\nX-Mailer: HIDDEN X MAILER\nBcc: hidden@example.com\n\nVISIBLE BODY\n')
   rc=root/'neomuttrc';rc.write_text('set quit=no\nset sort=date\nset beep=no\n'+ '\n'.join(line for line in config.splitlines() if line.startswith(('ignore ','unignore ','hdr_order ','set weed')))+'\n')
   master,slave=pty.openpty(); fcntl.ioctl(slave,termios.TIOCSWINSZ,struct.pack('HHHH',40,120,0,0)); worker=subprocess.Popen(['/usr/bin/neomutt','-n','-R','-F',str(rc),'-f',str(mail)],stdin=slave,stdout=slave,stderr=slave,env=dict(os.environ,TERM='xterm',LANG='C.UTF-8',LINES='40',COLUMNS='120'));os.close(slave)
   def read_until(text):
    result=b'';deadline=time.monotonic()+5
    while text not in result and time.monotonic()<deadline:
     if select.select([master],[],[],.1)[0]:
      try:result+=os.read(master,65536)
      except OSError:break
    return result
   try:
    initial=read_until(b'FILTER SUBJECT');os.write(master,b'\n');screen=read_until(b'VISIBLE BODY')
    self.assertIn(b'VISIBLE BODY',screen,repr(initial))
    for hidden in (b'HIDDEN ORGANIZATION',b'HIDDEN USER AGENT',b'HIDDEN X MAILER',b'hidden@example.com'):self.assertNotIn(hidden,screen)
    self.assertIn(b'From:',screen);self.assertIn(b'To:',screen)
   finally:
    worker.terminate();worker.communicate(timeout=5);os.close(master)
if __name__=='__main__':unittest.main()
