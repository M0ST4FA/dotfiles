import importlib.machinery, importlib.util, pathlib, unittest
SCRIPT=pathlib.Path(__file__).resolve().parents[1]/'stow/neomutt/.local/bin/mail-mirror-config'
class QuotaTests(unittest.TestCase):
 def test_newest_unread_and_flagged_do_not_consume_ordinary_quota(self):
  self.assertTrue(SCRIPT.exists(),'Folder quota generator is missing')
  loader=importlib.machinery.SourceFileLoader('mail_mirror_config',str(SCRIPT)); spec=importlib.util.spec_from_loader(loader.name,loader); module=importlib.util.module_from_spec(spec); loader.exec_module(module)
  ordinary=list(range(1,131)); all_uids=list(range(1,141))
  self.assertEqual(module.folder_limit(all_uids,ordinary),110)
  self.assertEqual(module.folder_limit(all_uids,list(range(11,141))),100)
  self.assertEqual(module.folder_limit(all_uids,[]),140)
  self.assertEqual(module.folder_limit([],[]),1)
 def test_missing_ordinary_history_requests_old_messages(self):
  self.assertTrue(SCRIPT.exists())
  loader=importlib.machinery.SourceFileLoader('quota_history',str(SCRIPT));spec=importlib.util.spec_from_loader(loader.name,loader);module=importlib.util.module_from_spec(spec);loader.exec_module(module)
  self.assertTrue(hasattr(module,'needs_history'),'Missing history must be restored when a previously smaller limit skipped it')
  self.assertTrue(module.needs_history(68,120));self.assertFalse(module.needs_history(100,120));self.assertFalse(module.needs_history(50,50))
 def test_last_account_generated_policy_parses_in_mbsync(self):
  import tempfile,subprocess
  from unittest.mock import patch,MagicMock
  loader=importlib.machinery.SourceFileLoader('quota_parse',str(SCRIPT));spec=importlib.util.spec_from_loader(loader.name,loader);module=importlib.util.module_from_spec(spec);loader.exec_module(module)
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary)
   for store in ('far','near'):
    for part in ('cur','new','tmp'):(root/store/'INBOX'/part).mkdir(parents=True)
   source=f"Sync Pull\nCreate Near\nRemove None\nExpunge None\nSyncState *\n\nIMAPAccount nerdio-infra\nHost fixture\nUser test\nPassCmd \"/bin/echo fixture-password\"\n\nMaildirStore nerdio-infra-remote\nPath {root}/far/\nInbox {root}/far/INBOX\n\nMaildirStore nerdio-infra-local\nPath {root}/near/\nInbox {root}/near/INBOX\n\nChannel nerdio-infra\nSync New Gone Flags\nExpunge Both\nFar :nerdio-infra-remote:\nNear :nerdio-infra-local:\nPatterns INBOX\nMaxMessages 100\nExpireUnread no\nExpireSide Near\n\nGroup mail\nChannel nerdio-infra\n"
   client=MagicMock();client.select.return_value=('OK',[]);client.uid.return_value=('OK',[b' '.join(str(n).encode() for n in range(1,141))])
   with patch.object(module.imaplib,'IMAP4_SSL',return_value=client):generated=module.generate(source,'nerdio-infra')
   config=root/'mbsyncrc';config.write_text(generated)
   result=subprocess.run(['mbsync','-c',str(config),'mail'],capture_output=True,text=True);self.assertEqual(result.returncode,0,result.stderr)
if __name__=='__main__':unittest.main()

class RecentProtectedFixture(unittest.TestCase):
 def test_actual_mbsync_keeps_100_read_messages_plus_recent_protected_mail(self):
  import shutil,subprocess,tempfile
  if not shutil.which('mbsync'):self.skipTest('mbsync unavailable')
  loader=importlib.machinery.SourceFileLoader('quota_fixture',str(SCRIPT));spec=importlib.util.spec_from_loader(loader.name,loader);module=importlib.util.module_from_spec(spec);loader.exec_module(module)
  with tempfile.TemporaryDirectory() as temporary:
   root=pathlib.Path(temporary)
   for store in ('far','near'):
    for part in ('cur','new','tmp'):(root/store/'INBOX'/part).mkdir(parents=True)
   (root/'far/INBOX/.uidvalidity').write_text('1\n140\n')
   for uid in range(1,141):
    flags='S' if uid<=130 else '' if uid<=135 else 'FS'
    (root/'far/INBOX/cur'/f'{uid:04},U={uid}:2,{flags}').write_text(f'Message-ID: <{uid}@quota>\n\nfixture\n')
   quota=module.folder_limit(list(range(1,141)),list(range(1,131)))
   config=root/'mbsyncrc';config.write_text(f'''Sync Pull
Create Near
Remove None
Expunge None
SyncState *
MaildirStore far
Path {root}/far/
Inbox {root}/far/INBOX

MaildirStore near
Path {root}/near/
Inbox {root}/near/INBOX

Channel test
Far :far:
Near :near:
Patterns INBOX
MaxMessages {quota}
ExpireSide Near
ExpireUnread no
''')
   result=subprocess.run(['mbsync','-c',str(config),'test'],capture_output=True,text=True);self.assertEqual(result.returncode,0,result.stderr)
   messages=list((root/'near/INBOX/cur').iterdir())+list((root/'near/INBOX/new').iterdir())
   ordinary=[p for p in messages if p.name.partition(':2,')[2]=='S']
   self.assertEqual(len(ordinary),100);self.assertEqual(len(messages),110);self.assertEqual(len(list((root/'far/INBOX/cur').iterdir())),140)
