"""Exercise installed mbsync's actual retention and two-way Maildir behavior."""
import pathlib, shutil, subprocess, tempfile, unittest
class RetentionTests(unittest.TestCase):
 def test_retention_flags_moves_and_deletion_keep_server_history(self):
  if not shutil.which('mbsync'): self.skipTest('mbsync is not installed')
  with tempfile.TemporaryDirectory() as directory:
   root=pathlib.Path(directory); far=root/'far'; near=root/'near'
   for store in (far,near):
    for box in ('INBOX','Trash'):
     for part in ('cur','new','tmp'): (store/box/part).mkdir(parents=True)
   (far/'INBOX/.uidvalidity').write_text('1\n140\n')
   for n in range(140):
    flags='' if n<5 else 'FS' if n<10 else 'S'
    (far/'INBOX/cur'/f'{n:04},U={n+1}:2,{flags}').write_text(f'Message-ID: <fixture-{n}@test>\nSubject: fixture\n\n{n}\n')
   config=root/'mbsyncrc'; config.write_text(f'''Sync Pull
Create Near
Remove None
Expunge None
SyncState *
MaildirStore far
Path {far}/
Inbox {far}/INBOX
SubFolders Verbatim

MaildirStore near
Path {near}/
Inbox {near}/INBOX
SubFolders Verbatim

Channel fixture
Far :far:
Near :near:
Patterns INBOX Trash
MaxMessages 100
ExpireSide Near
ExpireUnread no
''')
   def sync():
    result=subprocess.run(['mbsync','-c',str(config),'fixture'],capture_output=True,text=True)
    self.assertEqual(result.returncode,0,result.stderr)
   sync(); sync()
   messages=list((near/'INBOX/cur').glob('*'))+list((near/'INBOX/new').glob('*')); ordinary=[p for p in messages if 'S' in p.name.partition(':2,')[2] and 'F' not in p.name.partition(':2,')[2]]
   self.assertEqual(len(ordinary),100,'The mirror must retain 100 ordinary messages plus unread/flagged mail')
   self.assertEqual(len(messages),110); self.assertEqual(len(list((far/'INBOX/cur').glob('*'))),140)
   # Enable two-way sync, then a flag, a move, and an explicit delete.
   config.write_text(config.read_text().replace('Sync Pull','Sync New Gone Flags').replace('Expunge None','Expunge Both'))
   chosen=ordinary[-1]; message_id=chosen.read_text().splitlines()[0]
   flagged=chosen.with_name(chosen.name.rsplit(':2,',1)[0]+':2,FS'); chosen.rename(flagged); sync()
   remote=next(p for p in (far/'INBOX/cur').iterdir() if p.read_text().splitlines()[0]==message_id); self.assertIn('F',remote.name.split(':2,')[1])
   flagged.rename(near/'Trash/cur'/'moved:2,FS'); sync()
   self.assertFalse(any(p.read_text().splitlines()[0]==message_id for p in (far/'INBOX/cur').iterdir()))
   self.assertTrue(any(p.read_text().splitlines()[0]==message_id for p in (far/'Trash/cur').iterdir()))
   for p in (near/'Trash/cur').iterdir(): p.unlink()
   sync(); self.assertFalse(list((far/'Trash/cur').iterdir()))
   # Only the intentionally moved/deleted message disappeared remotely.
   self.assertEqual(len(list((far/'INBOX/cur').iterdir())),139)
if __name__=='__main__': unittest.main()
