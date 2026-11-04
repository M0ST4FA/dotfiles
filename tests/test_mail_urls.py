"""Real urlscan must run from a direct-colour NeoMutt terminal."""
import fcntl
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


class UrlTests(unittest.TestCase):
    def test_urlscan_opens_from_both_profiles_with_direct_colour_term(self):
        for profile, context in ((profile, context) for profile in ('neomuttrc', 'online/neomuttrc') for context in ('index', 'attach')):
            with self.subTest(profile=profile, context=context), tempfile.TemporaryDirectory() as temporary:
                root = Path(temporary)
                mail = root/'mail'
                for part in ('cur', 'new', 'tmp'):
                    (mail/part).mkdir(parents=True)
                (mail/'cur/old:2,S').write_text('From: sender@example.com\nSubject: URL FIXTURE\n\nhttps://example.com/urlscan-fixture\n')
                lines = (REPO/'stow/neomutt/.config/neomutt'/profile).read_text().splitlines()
                rc = root/'neomuttrc'
                rc.write_text(f'set folder="{mail}"\nset quit=yes\nset wait_key=no\n'+ '\n'.join(line for line in lines if 'urlscan' in line)+'\n')
                master, slave = pty.openpty()
                fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack('HHHH', 40, 120, 0, 0))
                process = subprocess.Popen(['/usr/bin/neomutt', '-n', '-F', str(rc), '-f', str(mail)],
                                           stdin=slave, stdout=slave, stderr=slave, start_new_session=True,
                                           preexec_fn=lambda: fcntl.ioctl(0, termios.TIOCSCTTY, 0),
                                           env=dict(os.environ, HOME=str(root), TERM='xterm-direct', SHELL='/bin/sh', LINES='40', COLUMNS='120'))
                os.close(slave)
                def read_until(needle):
                    output = b''
                    deadline = time.monotonic()+5
                    while needle not in output and time.monotonic() < deadline:
                        if select.select([master], [], [], .1)[0]:
                            try:
                                output += os.read(master, 65536)
                            except OSError:
                                break
                    return output
                try:
                    self.assertIn(b'URL FIXTURE', read_until(b'URL FIXTURE'))
                    if context == 'attach':
                        os.write(master, b'v')
                        self.assertIn(b'text/plain', read_until(b'text/plain'))
                    # Ctrl-B is the conventional URL chooser key.
                    os.write(master, b'\x02')
                    output = read_until(b'urlscan-fixture')
                    self.assertIn(b'urlscan-fixture', output, output)
                    self.assertNotIn(b'Traceback', output)
                    os.write(master, b'q')
                    if context == 'attach':
                        read_until(b'text/plain')
                        os.write(master, b'q')
                    read_until(b'URL FIXTURE')
                    os.write(master, b'q')
                    process.wait(timeout=5)
                finally:
                    if process.poll() is None:
                        os.killpg(process.pid, signal.SIGKILL)
                    process.communicate(timeout=5)
                    os.close(master)


if __name__ == '__main__':
    unittest.main()
