"""Exercise the real NeoMutt UI with desktop PATH and terminal flow control."""
import fcntl
import json
import os
from pathlib import Path
import pty
import select
import signal
import struct
import subprocess
import tempfile
import termios
import time
import unittest

REPO = Path(__file__).resolve().parents[1]
BIN = REPO/'stow/neomutt/.local/bin'


class FetchTests(unittest.TestCase):
    def test_control_s_returns_while_sync_runs_and_reports_status(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            self.mail = root/'mail'
            binary = root/'.local/bin'
            binary.mkdir(parents=True)
            for part in ('cur', 'new', 'tmp'):
                (self.mail/part).mkdir(parents=True)
            (self.mail/'cur/old:2,S').write_text('From: old@example.com\nSubject: OLD MESSAGE\n\nold\n')
            (binary/'mail-sync-ui').symlink_to(BIN/'mail-sync-ui')
            mock = binary/'systemctl'
            mock.write_text('''#!/usr/bin/python3
import json,os,sys,subprocess
from pathlib import Path
root=Path(os.environ['HOME'])
(root/'arguments').write_text(json.dumps(sys.argv[1:]))
if 'start' in sys.argv:
    subprocess.Popen([sys.executable,str(root/'receive.py')],stdin=subprocess.DEVNULL,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL,start_new_session=True)
else:
    print('ActiveState=activating\\nResult=success')
''')
            (root/'receive.py').write_text("import time;from pathlib import Path;time.sleep(2);Path("+repr(str(self.mail/'new/fetched'))+").write_text("+repr('From: sender@example.com\nSubject: NEW OTP\n\nfixture\n')+")")
            mock.chmod(0o755)
            config = (REPO/'stow/neomutt/.config/neomutt/neomuttrc').read_text()
            lines = [line for line in config.splitlines() if line.startswith((r'macro index,pager \cs', 'macro index,pager ,s'))]
            rc = root/'neomuttrc'
            rc.write_text(f'set folder="{self.mail}"\nset quit=yes\nset wait_key=no\nset mail_check=1\nset timeout=1\n'+ '\n'.join(lines)+'\n')
            master, slave = pty.openpty()
            attributes = termios.tcgetattr(slave)
            attributes[0] |= termios.IXON
            termios.tcsetattr(slave, termios.TCSANOW, attributes)
            fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack('HHHH', 40, 120, 0, 0))
            worker = subprocess.Popen([str(BIN/'neomutt'), '-n', '-F', str(rc), '-f', str(self.mail)],
                                      stdin=slave, stdout=slave, stderr=slave, start_new_session=True,
                                      env=dict(os.environ, HOME=str(root), XDG_STATE_HOME=str(root/'state'),
                                               PATH='/usr/bin:/bin', TERM='xterm', SHELL='/bin/sh', LINES='40', COLUMNS='120'))
            def read_until(needle, timeout=5):
                output = b''
                deadline = time.monotonic()+timeout
                while needle not in output and time.monotonic() < deadline:
                    if select.select([master], [], [], .1)[0]:
                        try:
                            output += os.read(master, 65536)
                        except OSError:
                            break
                return output
            try:
                self.assertIn(b'OLD MESSAGE', read_until(b'OLD MESSAGE'))
                start = time.monotonic()
                os.write(master, b'\x13')
                screen = read_until(b'Keep reading', 1.5)
                self.assertIn(b'Keep reading', screen, screen)
                self.assertLess(time.monotonic()-start, 1.5)
                self.assertEqual(json.loads((root/'arguments').read_text()), ['--user', 'start', '--no-block', 'mail-sync.service'])
                self.assertFalse((self.mail/'new/fetched').exists(), 'The macro must return before sync completes')
                os.write(master, b',s')
                self.assertIn(b'running in background', read_until(b'running in background'))
                self.assertIn(b'NEW OTP', read_until(b'NEW OTP'), 'New mail must appear while the client stays open')
                os.write(master, b'q')
                worker.wait(timeout=5)
                self.assertTrue(termios.tcgetattr(slave)[0] & termios.IXON)
            finally:
                if worker.poll() is None:
                    os.killpg(worker.pid, signal.SIGKILL)
                worker.communicate(timeout=5)
                os.close(master)
                os.close(slave)


if __name__ == '__main__':
    unittest.main()
