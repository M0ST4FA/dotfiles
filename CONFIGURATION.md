# Configuration ownership and recovery

New Stow packages link individual preference files into the home directory. Some
older packages still have folded directory links; inspect those before allowing an
application to generate additional files there. Ansible registers
packages in `roles/thelaptop/tasks/stow.yml` and installs their dependencies from the
existing package categories. Run Stow with `--no-folding` so application directories
remain ordinary directories and newly generated files stay outside this repository.

```sh
stow --no --no-folding -v -d ~/dotfiles/stow -t ~ PACKAGE
stow --no-folding -v -d ~/dotfiles/stow -t ~ PACKAGE
```

Back up conflicting ordinary files before activation; do not use `--adopt` blindly.
To remove managed links, use `stow -D --no-folding -d ~/dotfiles/stow -t ~ PACKAGE`.
Existing uncommitted preferences were retained during this integration. Local backups
are under `~/.local/state/dotfiles-integration/`; they are private recovery data.
No credentials, messages, queue jobs, journal content, or Bitwarden vault data belong
in this repository. Bitwarden CLI's existing local files and integration are retained.

## Added preference packages

All paths in this table are relative to `~`. Edit the linked file to customize it.

| Package | Managed files | Customization and local data |
| --- | --- | --- |
| desktop-portal | `.config/xdg-desktop-portal/hyprland-portals.conf` | Hyprland/GTK defaults, termfilechooser for file dialogs. The previous `config` filename was unsupported; it is backed up. |
| termfilechooser | `.config/xdg-desktop-portal-termfilechooser/config` | Installed configuration copied out of `/usr/share`; Yazi chooser, Kitty terminal. Save/Open modes and help-file behavior are configurable here. |
| qalculate | `.config/qalculate/qalc.cfg` | Existing precision, display and calculation preferences. |
| pet | `.config/pet/config.toml`, `.config/pet/snippet.toml` | Both existing snippets are entries in `snippet.toml`. Token fields are empty. Keep credentials in local environment/keyring configuration; never fill tokens in the tracked file. |
| jrnl | `.config/jrnl/jrnl.yaml` | Encryption remains enabled; journal remains `~/.local/share/jrnl/journal.txt`. Journal content and its password/keyring stay local. |
| godot | `.config/godot/editor_settings-4.7.tres` | Existing editor preferences; projects, recent directories, caches and imported assets stay local. Future editor-version filenames need deliberate migration. |
| flow-state | `.config/flow_state/habits.toml`, `notification.toml` | Habit definitions and notification preferences; progress/history remains local. |
| codex | `.codex/config.toml`, `.config/codex/prefs.json` | CLI configuration and the separate named app's preferences retained. Authentication, sessions, app documents, downloads and caches stay local. |
| antigravity | `.gemini/antigravity-cli/settings.json` | Existing CLI settings retained, including current permissions and workspace trust. Authentication and generated state stay local. |
| ghcup | `.ghcup/config.yaml` | Manager preferences only. Toolchains, cache, logs, downloads and generated `env` remain local. |

Flow State is installed by Ansible with the existing Cargo pin:

```sh
cargo install flow_state --version 1.0.6 --locked
```

The task skips an existing executable, preserving an existing installation. To change
versions deliberately, adjust the pin and reinstall. Rust is in the development category.

For GHCup, follow the [official installation instructions](https://www.haskell.org/ghcup/install/)
and install the versions required by your projects with `ghcup tui` or `ghcup install`.
The shell's existing `~/.ghcup/env` integration remains local. Stow the manager preference
file after bootstrap; do not Stow the entire `.ghcup` directory.

## Noctalia

`~/.config/noctalia/config.toml` is the curated base. Appearance, widgets, plugin settings
and automation were captured from the current merged configuration. GUI overrides are
an ordinary local file at `~/.local/state/noctalia/settings.toml`; they take precedence
and remain outside Git. The version marker and `wallpaper.last` remain local.
Other runtime files—including clipboard history, notification history, downloaded
plugins, screen time, usage counters and wallpaper shuffle state—remain untouched.
This uses Noctalia's [base and GUI override model](https://docs.noctalia.dev/noctalia/configuration/).

```sh
noctalia-dotfiles capture
noctalia-dotfiles reset-overrides
noctalia config validate
```

Capture exports `merged` preferences, removes `config_version` and `wallpaper.last`,
validates the result, backs up the previous base, and atomically replaces the repository
file while preserving the Stow link. It never commits. Failed export, parsing or
validation leaves the previous base intact.

Reset backs up and clears GUI configuration overrides, retaining `config_version`
and `wallpaper.last`. Use it when a GUI override prevents a manual base edit from
appearing. Noctalia watches both layers. Helpers respect Noctalia-specific and XDG
configuration/state roots. Backups are in the resolved state root's
`noctalia-dotfiles/backups/`; do not put backups ending in `.toml` beside the base,
since Noctalia would merge them as additional configuration.

Niri starts `noctalia` and its shortcuts use `noctalia msg` v5 commands. Hyprland's
Yazi command is `kitty yazi`; the obsolete Quickshell lock command was replaced.
The unused broken Kitty `theme.conf` link was removed; `current-theme.conf` remains.

## Local mail

Normal `neomutt` and the Noctalia launcher read local Maildirs. `neomutt --online`
uses the retained IMAP profile for older mail, remote-only archives, and recovery.
The four accounts, identities, aliases, Nord colors, Neovim editor, HTML rendering
and URL tools remain available. Normal message view shows only From, To, Cc, Date
and Subject. Press `h` to toggle full headers.

| Key | Action |
| --- | --- |
| F2 | Infrastructure Inbox |
| F3 | Support Inbox |
| F4 | Mostafa Nerdio Inbox |
| F5 | Gmail Inbox |
| Ctrl-P / Ctrl-N / Ctrl-O | Previous / next / open sidebar mailbox |
| B | Toggle sidebar |
| Alt-X | Notmuch query over downloaded mail |
| `$` | Save local mailbox changes; may ask to purge messages marked for deletion |
| Ctrl-S | Fetch all accounts, index, and refresh the current view |
| V | Read decoded mail in Neovim |
| Ctrl-U | Select a message URL |

The online profile preserves its original F2/F3/F4 account order and adds F5 for
Mostafa Nerdio. Account-specific Notmuch views cover all mirrored folders. In a
cross-account search, switch to the intended account before composing a new message.
Notmuch searches only downloaded history; use the online profile for older messages.

Mail lives under `~/.local/share/mail/ACCOUNT/`. Nerdio mirrors `INBOX`, `Sent`,
`Drafts` and `Trash`; Gmail mirrors `INBOX`, `[Gmail]/Sent Mail`, `[Gmail]/Drafts`
and `[Gmail]/Trash`. Remote discovery confirmed these names for all four accounts.
Native synchronization state is `.mbsyncstate` inside each folder. Never delete or
edit synchronization state casually: it distinguishes local expiration from a
user's intentional deletion.

### Retention and synchronization

The target is 100 ordinary read, unflagged messages per folder, plus unread and flagged
messages. A folder with fewer ordinary messages retains what exists. Older history
remains on the server. `mail-mirror-config` makes read-only IMAP UID searches and
calculates a separate native `MaxMessages` limit for each folder: recent protected
messages must not consume the 100 ordinary slots. Runtime configurations are private
files under `~/.local/state/mail-sync/`. The source is `~/.config/isync/mbsyncrc`.
`mail-sync` uses these calculated limits; invoking plain `mbsync` against the source
uses its conservative 100-message fallback instead.

```sh
mail-sync
notmuch new
```

The global defaults are pull-only. All four current channels were individually
validated and enabled for two-way synchronization. For a new account, validate its
folder discovery and initial pull before adding these options inside its Channel section:

```text
Sync New Gone Flags
Expunge Both
```

Keep `ExpireSide Near`, `ExpireUnread no`, `Remove None`, and `Create Near`.
Native retention expiration stays local; explicit filing/deletion inside mirrored
folders propagates once that account is enabled for two-way synchronization.
Remote-only archives remain available online. A manually deleted ordinary message
can leave fewer than 100 local ordinary messages until new mail arrives: mbsync does
not automatically recreate history below its recorded expiration boundary.

Use the guarded bootstrap to establish or rebuild a complete ordinary-message window:

```sh
mail-bootstrap ACCOUNT
```

It downloads into a separate private staging directory with pull-only operations,
validates actual folder counts, and promotes only if NeoMutt is closed and the live
mailbox has not changed during download. It also compares local messages and flags
against native synchronization state and refuses unsynchronized edits, new messages,
or deletions. Run `mail-sync` successfully before rebuilding a populated mirror. The launcher holds a shared view lock;
promotion holds it exclusively until Notmuch indexing completes. An indexing failure
restores the old mailbox. Previous mailboxes and failed staging runs remain under
`~/.local/state/mail-bootstrap/`. Direct `/usr/bin/neomutt` calls bypass the launcher
lock, so bootstrap also checks for existing NeoMutt processes. Never manually replace
an open mailbox directory: cached filenames become invalid and can resemble deleted
mail. If the index is stale, close the client, run `notmuch new`, and reopen it.

`neomutt-credentials` keeps the original `username:`/`password:` interface for NeoMutt
and supports `--password-only` for mbsync, msmtp, and metadata queries. Credentials
remain in GNOME Keyring, selected by `application=neomutt`, account address, hostname,
and protocol (`imaps` or `smtps`). No helper prints credentials in diagnostic output.

### Offline submission queue

```sh
mail-submit ACCOUNT [SENDMAIL-ARGS...]
mail-queue status
mail-queue-flush [ACCOUNT]
mail-queue retry ACCOUNT [JOB]
```

NeoMutt invokes `mail-submit` with the exact envelope arguments, including Bcc recipients.
Submission writes the complete message and argument list into a private durable queue
and triggers delivery asynchronously. Once committed, offline delivery failure does
not fail submission. Queue messages and metadata are mode 0600 inside mode 0700
directories under `~/.local/state/mail-queue/`; do not commit or publicly back them up.

`new` jobs await delivery; `sending` jobs are in progress. After an interruption,
`sending` jobs become `held` because SMTP may already have accepted them. Explicit
`retry` releases held jobs; check the recipient/server first to avoid duplicate delivery,
then run the worker. A nonzero SMTP result returns the job to `new` for later retry.
`delivered` jobs need only final Sent-copy handling, never another SMTP attempt.
Nerdio gets one local read Sent copy after confirmed delivery. Gmail supplies its own
server-generated Sent copy. NeoMutt's local `record` is disabled to avoid premature
or duplicate Sent copies. The SMTP worker and native sync use locks against overlap;
The sync service passes its locked descriptor to its child worker; independently
triggered workers defer when receiving is in progress. Sent-copy creation also honors the mailbox promotion lock.

The delivery service retries pending jobs; manual `mail-sync` also invokes it. Delivery
failure does not prevent receiving or indexing, and one failed account does not prevent
other accounts from syncing. The session timer first runs after two minutes, then five
minutes after the previous run finishes. A Wayland lifetime service activates the
otherwise inactive graphical target in direct Hyprland sessions and stops it at logout.
The timer is enabled under `graphical-session.target`; compositor startup imports the
Wayland environment and starts the session bridge.

```sh
systemctl --user daemon-reload
systemctl --user enable mail-sync.timer
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
systemctl --user start mail-session.service
systemctl --user list-timers mail-sync.timer
journalctl --user -u mail-sync.service -u mail-delivery.service
```

To stop automatic receiving, use `systemctl --user stop mail-sync.timer`. To disable it
for future sessions, use `systemctl --user disable mail-sync.timer`. Queued submissions
can still trigger the delivery service; stop that service separately when investigating
an uncertain SMTP outcome.

## Verification and rollback

The tracked `tests/` suite uses temporary Maildirs, synthetic messages, mocked SMTP,
real mbsync fixture synchronization, and a temporary Unix socket. It covers queue
failures, recovery, concurrency, envelope/Bcc arguments, Sent copies, retention,
flags/moves/deletion, generated configuration parsing, pager header filtering, session
lifetime, capture failures, link preservation, override reset, and safe bootstrap rollback.
It neither reads live credentials nor contacts live servers.

```sh
python -m unittest discover -s tests
ansible-playbook -i localhost, ansible/local.yml --syntax-check
noctalia config validate
# Only when Niri is installed:
niri validate -c ~/.config/niri/config.kdl
systemd-analyze --user verify ~/.config/systemd/user/mail-{sync,delivery,session}.service ~/.config/systemd/user/mail-sync.timer
```

Python requires `tomlkit`; fixture tests use installed `mbsync` and `neomutt`. These
checks do not run the Ansible provisioning playbook or send a live email. Remaining
interactive checks include portal Open/single selection/multiple selection/directory
selection/Save, actual compositor shortcuts, and a Noctalia restart. Check a live
SMTP send deliberately after confirming its envelope and account.

For rollback, stop mail timers/workers, close NeoMutt, and open `neomutt --online`.
Keep queued jobs until each message's delivery outcome is known. Restore both a
Maildir and its matching native sync state from the same backup; never combine state
from a different mirror with live mail. Run `notmuch new` before reopening local mail.
Restore a Noctalia base backup through its repository target, and restore a GUI backup
as an ordinary state file. To restore an app's pre-Stow file, unstow its package first,
then copy the local backup into place. Git commits can revert preference changes,
but runtime data and backups are deliberately outside Git.

## Existing package audit and inventory

The integration registers the existing MIME package and fixes missing provisioning
for existing configurations (fastfetch, Taskwarrior TUI, mpv, OpenRazer,
and the keyring helper). Each primary package remains in exactly one category. The
Neovim feature-set variable's category spelling was corrected.
Config files alone do not justify installing an absent application. Niri and xsettingsd
are intentionally omitted from the installation catalog. The termfilechooser entry
uses the already-installed `xdg-desktop-portal-termfilechooser-hunkyburrito-git` variant.
Niri configurations remain tracked for preservation. Validation used a temporary binary from the existing
package cache and did not install the compositor.
Legacy AnyRun/Hyprpanel and hand-built emulator configurations remain tracked without
activating another shell or adding apps. Existing historical `.bak`/`.bk` preference
copies remain unchanged. Cursor aliases refer to intentionally untracked, generated
Nordic cursor binaries; regenerate those assets as described in the README. Newly
managed directories and Polychromatic preferences use individual file links, keeping
their mutable state outside the repository. Bytecode is ignored by Git and by the mail Stow package.

The inventory below lists the managed paths within each package. Paths are relative
to the home directory. Runtime state and downloaded submodules are described separately.

| Package | Managed paths |
| --- | --- |
| antigravity | `.gemini/antigravity-cli/settings.json` |
| anyrun | `.config/anyrun/config.ron`<br>`.config/anyrun/rink.ron`<br>`.config/anyrun/style.css`<br>`.config/anyrun/style.css.bk` |
| btop | `.config/btop/btop.conf` |
| clang | `.clang-format` |
| clangd | `.config/clangd/config.yaml` |
| codex | `.codex/config.toml`<br>`.config/codex/prefs.json` |
| desktop-portal | `.config/xdg-desktop-portal/hyprland-portals.conf` |
| fastfetch | `.config/fastfetch/ascii.txt`<br>`.config/fastfetch/config.jsonc` |
| flow-state | `.config/flow_state/habits.toml`<br>`.config/flow_state/notification.toml` |
| fontconfig | `.config/fontconfig/fonts.conf` |
| foot | `.config/foot/dank-colors.ini`<br>`.config/foot/foot.ini` |
| gdb | `.config/gdb/gdbinit` |
| ghcup | `.ghcup/config.yaml` |
| git | `.gitconfig`<br>`.gitignore_global` |
| godot | `.config/godot/editor_settings-4.7.tres` |
| hyprland | `.config/hypr/dms/colors.conf`<br>`.config/hypr/hypridle.conf`<br>`.config/hypr/hyprland.d/animations.lua`<br>`.config/hypr/hyprland.d/autostart.lua`<br>`.config/hypr/hyprland.d/colors.lua`<br>`.config/hypr/hyprland.d/decoration.lua`<br>`.config/hypr/hyprland.d/environment.lua`<br>`.config/hypr/hyprland.d/gestures.lua`<br>`.config/hypr/hyprland.d/input.lua`<br>`.config/hypr/hyprland.d/keybinds.lua`<br>`.config/hypr/hyprland.d/layerrules.lua`<br>`.config/hypr/hyprland.d/layout.lua`<br>`.config/hypr/hyprland.d/misc.lua`<br>`.config/hypr/hyprland.d/permissions.lua`<br>`.config/hypr/hyprland.d/plugins.lua`<br>`.config/hypr/hyprland.d/theme.lua`<br>`.config/hypr/hyprland.d/variables.lua`<br>`.config/hypr/hyprland.d/windowrules.lua`<br>`.config/hypr/hyprland.d/xwayland.lua`<br>`.config/hypr/hyprland.lua`<br>`.config/hypr/hyprlock.conf`<br>`.config/hypr/hyprpaper.conf`<br>`.config/hypr/hyprtoolkit.conf`<br>`.config/hypr/scripts/brightness-osd.sh`<br>`.config/hypr/scripts/ocr.sh`<br>`.config/hypr/scripts/volume-wpctl-osd.sh`<br>`.local/bin/screenshot` |
| hyprpanel | `.config/hyprpanel/config.json`<br>`.config/hyprpanel/modules.json`<br>`.config/hyprpanel/modules.scss` |
| jrnl | `.config/jrnl/jrnl.yaml` |
| kitty | `.config/kitty/current-theme.conf`<br>`.config/kitty/kitty-themes`<br>`.config/kitty/kitty.conf`<br>`.config/kitty/kitty.conf.bak` |
| kvantum | `.config/Kvantum/Utterly-Nord/LICENSE.md`<br>`.config/Kvantum/Utterly-Nord/Nord.patchconfig`<br>`.config/Kvantum/Utterly-Nord/Utterly-Nord.kvconfig`<br>`.config/Kvantum/Utterly-Nord/Utterly-Nord.svg`<br>`.config/Kvantum/kvantum.kvconfig` |
| mame | `.mame/cfg/bbcb.cfg`<br>`.mame/cfg/bbcbp.cfg`<br>`.mame/cfg/bbcm.cfg`<br>`.mame/cfg/default.cfg`<br>`.mame/mame.ini`<br>`.mame/ui.ini` |
| mimeapps | `.config/mimeapps.list` |
| mpd | `.config/mpd/mpd.conf` |
| mpv | `.config/mpv/mpv.conf` |
| neomutt | `.config/isync/mbsyncrc`<br>`.config/msmtp/config`<br>`.config/neomutt/accounts/gmail.rc`<br>`.config/neomutt/accounts/local.rc`<br>`.config/neomutt/accounts/nerdio.rc`<br>`.config/neomutt/aliases.rc`<br>`.config/neomutt/colors-nord-truecolor.rc`<br>`.config/neomutt/colors-nord.rc`<br>`.config/neomutt/mailcap`<br>`.config/neomutt/neomuttrc`<br>`.config/neomutt/notmuch.rc`<br>`.config/neomutt/online/accounts/gmail.rc`<br>`.config/neomutt/online/accounts/nerdio.rc`<br>`.config/neomutt/online/neomuttrc`<br>`.config/notmuch/default/config`<br>`.config/systemd/user/mail-delivery.service`<br>`.config/systemd/user/mail-session.service`<br>`.config/systemd/user/mail-sync.service`<br>`.config/systemd/user/mail-sync.timer`<br>`.local/bin/mail-bootstrap`<br>`.local/bin/mail-mirror-config`<br>`.local/bin/mail-queue`<br>`.local/bin/mail-queue-flush`<br>`.local/bin/mail-session`<br>`.local/bin/mail-submit`<br>`.local/bin/mail-sync`<br>`.local/bin/neomutt`<br>`.local/bin/neomutt-colors`<br>`.local/bin/neomutt-credentials`<br>`.local/bin/neomutt-store-password`<br>`.local/share/applications/neomutt.desktop` |
| niri | `.config/niri/config.kdl`<br>`.config/niri/dms/alttab.kdl`<br>`.config/niri/dms/binds.kdl`<br>`.config/niri/dms/colors.kdl`<br>`.config/niri/dms/cursor.kdl`<br>`.config/niri/dms/layout.kdl`<br>`.config/niri/dms/outputs.kdl`<br>`.config/niri/dms/windowrules.kdl`<br>`.config/niri/dms/wpblur.kdl`<br>`.config/niri/niri.d/animations.kdl`<br>`.config/niri/niri.d/binds.kdl`<br>`.config/niri/niri.d/colors.kdl`<br>`.config/niri/niri.d/environment.kdl`<br>`.config/niri/niri.d/gestures.kdl`<br>`.config/niri/niri.d/input.kdl`<br>`.config/niri/niri.d/layerrules.kdl`<br>`.config/niri/niri.d/layout.kdl`<br>`.config/niri/niri.d/outputs.kdl`<br>`.config/niri/niri.d/windowrules.kdl`<br>`.config/niri/niri.d/workspaces.kdl` |
| noctalia | `.config/noctalia/config.toml`<br>`.local/bin/noctalia-dotfiles` |
| nvim | `.config/nvim/init.lua`<br>`.config/nvim/lua/core/colorscheme.lua`<br>`.config/nvim/lua/core/completion.lua`<br>`.config/nvim/lua/core/keymaps.lua`<br>`.config/nvim/lua/core/lazy.lua`<br>`.config/nvim/lua/core/neovide.lua`<br>`.config/nvim/lua/core/options.lua`<br>`.config/nvim/lua/plugins/dankcolors.lua`<br>`.config/nvim/lua/plugins/editor.lua`<br>`.config/nvim/lua/plugins/lsp.lua`<br>`.config/nvim/lua/plugins/misc.lua`<br>`.config/nvim/lua/plugins/theme.lua`<br>`.config/nvim/lua/plugins/ui.lua` |
| nwg-look | `.config/gtk-3.0/settings.ini`<br>`.config/gtk-4.0/settings.ini`<br>`.config/nwg-look/config`<br>`.config/xsettingsd/xsettingsd.conf`<br>`.gtkrc-2.0`<br>`.icons/Nordic-cursors/index.theme`<br>`.icons/default/index.theme`<br>`.icons/Nordic-cursors/cursors/* (cursor-name aliases; binaries generated locally)` |
| openrazer | `.config/openrazer/persistence.conf`<br>`.config/openrazer/razer.conf` |
| pavucontrol | `.config/pavucontrol.ini` |
| pet | `.config/pet/config.toml`<br>`.config/pet/snippet.toml` |
| polychromatic | `.config/polychromatic/colours.json`<br>`.config/polychromatic/preferences.json` |
| qalculate | `.config/qalculate/qalc.cfg` |
| qt6ct | `.config/qt6ct/qt6ct.conf` |
| satty | `.config/satty/config.toml`<br>`.config/satty/overrides.css` |
| taskwarrior-tui | `.config/taskwarrior-tui/taskwarrior-tui.toml` |
| taskwarrior | `.config/task/hooks/on-modify.timewarrior`<br>`.config/task/taskrc` |
| termfilechooser | `.config/xdg-desktop-portal-termfilechooser/config` |
| timewarrior | `.config/timewarrior/timewarrior.cfg` |
| waypaper | `.config/waypaper/config.ini` |
| wezterm | `.config/wezterm/bar.lua`<br>`.config/wezterm/colors/dank-theme.toml`<br>`.config/wezterm/wezterm.lua` |
| wireshark | `.config/wireshark/cfilters`<br>`.config/wireshark/decode_as_entries`<br>`.config/wireshark/dfilter_buttons`<br>`.config/wireshark/dfilters`<br>`.config/wireshark/dmacros`<br>`.config/wireshark/extcap.cfg`<br>`.config/wireshark/io_graphs`<br>`.config/wireshark/language`<br>`.config/wireshark/plots`<br>`.config/wireshark/preferences`<br>`.config/wireshark/profiles/Bluetooth/colorfilters`<br>`.config/wireshark/profiles/Bluetooth/preferences`<br>`.config/wireshark/profiles/No Reassembly/extcap.cfg`<br>`.config/wireshark/profiles/No Reassembly/io_graphs`<br>`.config/wireshark/profiles/No Reassembly/plots`<br>`.config/wireshark/profiles/No Reassembly/preferences`<br>`.config/wireshark/profiles/Packet Bytes/extcap.cfg`<br>`.config/wireshark/profiles/Packet Bytes/io_graphs`<br>`.config/wireshark/profiles/Packet Bytes/preferences` |
| yazi | `.config/yazi/init.lua`<br>`.config/yazi/keymap.toml`<br>`.config/yazi/package.toml`<br>`.config/yazi/theme.toml`<br>`.config/yazi/yazi.toml`<br>`.local/share/applications/yazi.desktop` |
| zathura | `.config/zathura/noctaliarc`<br>`.config/zathura/zathurarc` |
| zsh | `.config/zshrc/00-init`<br>`.config/zshrc/20-customization`<br>`.config/zshrc/25-aliases`<br>`.config/zshrc/30-autostart`<br>`.config/zshrc/40-zoxide`<br>`.config/zshrc/50-completion`<br>`.p10k.zsh`<br>`.zshrc` |
