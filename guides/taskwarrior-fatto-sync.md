# Sync Taskwarrior with Fatto through the laptop

This is a manual setup guide. Saving it does not install or activate anything.
It targets Taskwarrior 3.5, Docker Compose, and an initially empty Fatto app.
Taskwarrior 3 uses TaskChampion; the older `taskd` server is incompatible.

The laptop runs the server. Fatto connects over shared Wi-Fi using
`http://thelaptop.local:8080`; the laptop itself uses `http://127.0.0.1:8080`.
The existing link-local DNS setup stays unchanged. No router port forwarding is
needed. Both clients work offline, but cannot exchange changes while the laptop
is asleep or unreachable.

The server stores encrypted task data. Both clients need the **same client UUID
and encryption secret**, even though they use different server URLs. The UUID
also serves as the server's access restriction. This HTTP setup assumes a trusted
LAN: task encryption does not encrypt HTTP headers or protect the UUID in transit.
IPv4 port 8080 will be available on the laptop's network interfaces, not just one
SSID. Do not forward it through the router.

## 1. Check prerequisites and back up

Confirm the installed tools and Docker access:

```sh
task --version
docker version
docker compose version
getent ahostsv4 thelaptop.local
ss -ltn 'sport = :8080'
```

Port 8080 must be free. On the phone, confirm `thelaptop.local` resolves using
its existing local-network setup; laptop-side resolution alone does not prove
phone-side resolution. Both devices must be on a network permitting communication
between clients, rather than an isolated guest network.

Close Taskwarrior/TUI clients before copying the database. These commands assume
the current `data.location=~/.local/share/task` and the existing Stow-linked config:

```sh
umask 077
backup_dir="$HOME/.local/state/taskwarrior/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
cp -a "$HOME/.local/share/task" "$backup_dir/data"
cp -L "$HOME/.config/task/taskrc" "$backup_dir/taskrc"
chmod 600 "$backup_dir/taskrc"
printf 'Backup: %s\n' "$backup_dir"
```

Keep the entire database backup, including any SQLite sidecar files. First sync
changes Taskwarrior's undo history; the database backup is the recovery point.
Do not synchronize the live database files with Syncthing, rsync, or Git.

## 2. Create private credentials

Keep the deployment outside the dotfiles checkout:

```sh
install -d -m 700 "$HOME/services/taskchampion"
install -d -m 700 "$HOME/.config/task"
python3 - <<'PY'
from pathlib import Path
import os
import secrets
import uuid

os.umask(0o077)
server_env = Path.home() / 'services/taskchampion/.env'
client_config = Path.home() / '.config/task/sync.rc'
if server_env.exists() or client_config.exists():
    raise SystemExit('Existing sync configuration found; inspect it instead of replacing credentials.')
client_id = str(uuid.uuid4())
secret = secrets.token_hex(32)
with server_env.open('x') as output:
    output.write(f'TASKCHAMPION_CLIENT_ID={client_id}\n')
with client_config.open('x') as output:
    output.write('sync.server.url=http://127.0.0.1:8080\n')
    output.write(f'sync.server.client_id={client_id}\n')
    output.write(f'sync.encryption_secret={secret}\n')
print('Created private server environment and Taskwarrior sync configuration.')
PY
```

Do not regenerate these credentials after tasks have been uploaded. Back up both
files privately. The encryption secret belongs only on clients, not on the server.

## 3. Run the server

Save this as `~/services/taskchampion/compose.yaml`:

```yaml
name: taskchampion-sync
services:
  server:
    image: ghcr.io/gothenburgbitfactory/taskchampion-sync-server:0.7.1
    restart: unless-stopped
    ports:
      - "0.0.0.0:8080:8080"
    environment:
      LISTEN: "0.0.0.0:8080"
      DATA_DIR: /var/lib/taskchampion-sync-server/data
      CLIENT_ID: "${TASKCHAMPION_CLIENT_ID:?Set TASKCHAMPION_CLIENT_ID in .env}"
      RUST_LOG: warn
    volumes:
      - data:/var/lib/taskchampion-sync-server/data
volumes:
  data:
    name: taskchampion-sync-data
```

The explicit IPv4 publication avoids unintentionally publishing on public IPv6.
The named volume survives container recreation. Do not use `down --volumes`.
The image is pinned; review and back up data before deliberately changing versions.

```sh
cd "$HOME/services/taskchampion"
docker compose config --quiet
docker compose up -d --wait
docker compose ps
curl --max-time 5 -sS -o /dev/null -w 'HTTP status: %{http_code}\n' http://127.0.0.1:8080/
```

The root path may return 404; receiving an HTTP response still confirms a listener.
Taskwarrior sync below verifies the actual protocol. Container logs may include
the client UUID at startup, so do not share them unredacted.

## 4. Connect Taskwarrior, then Fatto

Add this line once to `~/.config/task/taskrc`, after creating `sync.rc`:

```text
include ~/.config/task/sync.rc
```

That `taskrc` is Stow-linked into Git. Keep only the include line there; do not run
`task config sync.encryption_secret ...`, which would write the secret into it.

Seed the fresh server from the laptop:

```sh
task sync
```

Confirm success before connecting Fatto. On the phone, open Fatto's sync settings,
choose **Sync server**, and enter:

| Field | Value |
| --- | --- |
| Sync server URL | `http://thelaptop.local:8080` |
| Client ID (UUID) | `sync.server.client_id` from the private `sync.rc` |
| Encryption secret | `sync.encryption_secret` from the same file |

View the private file locally when entering the credentials. Do not paste it into
Git, chat, or a public issue. Fatto also supports importing taskrc text, but replace
the laptop's `127.0.0.1` URL with `thelaptop.local` before importing it on the phone.
An `include` line alone does not import the included file's contents.

Use **Save and test**, or the equivalent sync action in your installed Fatto
version. Existing laptop tasks should appear without resetting either client.

## 5. Test both directions before enabling automation

1. Check that existing tasks and their UUIDs survived the initial sync.
2. Add a temporary task on the laptop, run `task sync`, then sync Fatto.
3. Add another temporary task in Fatto, sync it, then run `task sync` on the laptop.
4. Test editing and completing the temporary tasks in each direction.
5. Verify a different client UUID is rejected: use an empty temporary Taskwarrior
   data directory and a command-line `rc.sync.server.client_id` override, never
   overwrite your real client ID or import a second copy of existing tasks.
6. Run `docker compose down` followed by `docker compose up -d --wait` and confirm
   tasks still synchronize. Leave the named volume intact.

A change reaches the other device only after both clients synchronize: the source
uploads, then the destination downloads. Synchronization is not instant push.

## 6. Automate laptop synchronization while awake

Create `~/.config/systemd/user/taskwarrior-sync.service`:

```ini
[Unit]
Description=Synchronize Taskwarrior through the laptop server

[Service]
Type=oneshot
WorkingDirectory=%h/services/taskchampion
Environment=TASKRC=%h/.config/task/taskrc
Environment=PATH=/usr/local/bin:/usr/bin
ExecStartPre=/usr/bin/docker compose up -d --wait
ExecStart=/usr/bin/task sync
TimeoutStartSec=2min
UMask=0077
```

The pre-start command ensures the server is running, including after boot. Docker
socket activation is already enabled on this laptop. Compose reads its private
`.env` from the working directory. If startup or sync fails, the error remains in
the user journal and the next timer run retries. A transient first-start connection
failure can be retried manually once the HTTP listener is ready.

Create `~/.config/systemd/user/taskwarrior-sync.timer`:

```ini
[Unit]
Description=Synchronize Taskwarrior while the laptop is awake

[Timer]
OnActiveSec=30s
OnCalendar=*:0/5
Persistent=true
WakeSystem=false
AccuracySec=15s

[Install]
WantedBy=timers.target
```

Validate, then enable:

```sh
systemd-analyze --user verify \
  "$HOME/.config/systemd/user/taskwarrior-sync.service" \
  "$HOME/.config/systemd/user/taskwarrior-sync.timer"
systemctl --user daemon-reload
systemctl --user enable --now taskwarrior-sync.timer
systemctl --user start taskwarrior-sync.service
systemctl --user list-timers taskwarrior-sync.timer
```

The timer runs shortly after activation and every five minutes while logged in.
Calendar runs missed during sleep catch up once after resume; it does not wake or
keep awake the laptop. Existing lid-close behavior is unchanged. No user lingering
is required. A running service is not started again by overlapping timer/manual
requests.

Fatto's current built-in background job runs hourly; Android may defer it. Keep
that behavior and use its manual action for immediate phone synchronization.

After enabling, test an offline edit and a suspend/resume cycle. Verify the user
journal shows a catch-up run and the phone can reconnect after Wi-Fi returns.

## Manual commands and troubleshooting

```sh
# Manual sync through the same service, starting the server if needed:
systemctl --user start taskwarrior-sync.service

# Direct sync when the server is already running:
task sync

# Status and detailed errors:
systemctl --user status taskwarrior-sync.service
journalctl --user -u taskwarrior-sync.service -n 40 --no-pager
systemctl --user list-timers taskwarrior-sync.timer

# Server status:
cd "$HOME/services/taskchampion"
docker compose ps
```

If the phone cannot connect, check shared Wi-Fi, client isolation, local DNS, and
whether the laptop is awake. `localhost` on the phone means the phone itself.
Do not solve connectivity problems by changing UUIDs, encryption secrets, or by
resetting existing tasks. A firewall introduced later must account for Docker's
published-port forwarding; do not assume a generic UFW input rule protects it.

## Stop or roll back

Stop automation before investigating or restoring data:

```sh
systemctl --user disable --now taskwarrior-sync.timer
systemctl --user stop taskwarrior-sync.service
cd "$HOME/services/taskchampion"
docker compose down
```

Keep the volume and credential files. To return to local-only Taskwarrior, also
remove/comment the `include ~/.config/task/sync.rc` line. The local tasks remain.
Disable Fatto synchronization before restoring an older laptop database; otherwise
later sync may merge newer remote changes back into it. Restore the entire database
backup with all Taskwarrior/TUI processes stopped. Re-enabling sync after a restore
requires reconciling the restored replica with the server, not blindly resetting it.

For a consistent server backup, stop the server and archive the named Docker
volume while stopped; keep that archive and the client encryption secret in private
backup storage. A server-volume backup alone cannot decrypt your task data.

## References

- [Taskwarrior synchronization](https://taskwarrior.org/docs/sync/)
- [Taskwarrior sync settings](https://taskwarrior.org/docs/man/task-sync.5/)
- [Official TaskChampion images](https://gothenburgbitfactory.org/taskchampion-sync-server/usage/docker-images.html)
- [Fatto](https://github.com/brokenpip3/fatto)
- [systemd timer suspend/resume behavior](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html)
