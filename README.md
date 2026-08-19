# Dotfiles

Personal Arch Linux configuration managed with GNU Stow and Ansible.

## Install

Clone the repository into the home directory:

```sh
git clone --recursive https://github.com/M0ST4FA/dotfiles.git ~/dotfiles
```

The laptop Ansible role installs every package listed in
`ansible/roles/thelaptop/tasks/stow.yml`. To install one package manually:

```sh
stow -v -d ~/dotfiles/stow -t ~ <package>
```

Preview it first when existing files may collide:

```sh
stow --no -v -d ~/dotfiles/stow -t ~ <package>
```

To remove only the links for a package:

```sh
stow -D -v -d ~/dotfiles/stow -t ~ <package>
```

## Generated configuration

### Yazi

`stow/yazi` tracks the hand-maintained configuration and `package.toml`
lockfile. Plugins and flavors are downloaded rather than committed:

```sh
ya pkg install
```

The Ansible role runs this command after stowing the configuration.

### Kvantum

The Utterly Nord SVG is generated from the tracked `Nord.patchconfig`.
The tracked `Utterly-Nord.kvconfig` must not be overwritten: it contains
manual transparency, blur, scrollbar, and application-opacity adjustments.

To recreate only the generated SVG:

```sh
kvantum_build_dir="$(mktemp -d)"
git clone https://github.com/HimDek/Utterly-Round-Plasma-Style.git "$kvantum_build_dir/upstream"
git -C "$kvantum_build_dir/upstream" checkout 7e011c19382f8afa99daac3226828ce82eaf4f13
bash "$kvantum_build_dir/upstream/kvantum/Utterly-Round-Transparent-Kvantum-Template/patch.sh" \
  --config ~/.config/Kvantum/Utterly-Nord/Nord.patchconfig \
  --template "$kvantum_build_dir/upstream/kvantum/Utterly-Round-Transparent-Kvantum-Template" \
  --save "$kvantum_build_dir/rendered"
install -m 0644 "$kvantum_build_dir/rendered/Utterly-Nord/Utterly-Nord.svg" \
  ~/.config/Kvantum/Utterly-Nord/Utterly-Nord.svg
```

The Nordic cursor binaries are also reproducible from
[EliverLara/Nordic](https://github.com/EliverLara/Nordic/tree/master/kde/cursors)
and are intentionally not stored here.

## Private and stateful data

NeoMutt reads its password from
`~/.config/neomutt/credentials.rc`. Restore that file separately with mode
`0600`; it must contain the private `set imap_pass = ...` setting and must
never be committed.

The following are backup/restore data, not Stow packages:

- SSH and GnuPG keys, keyrings, and device credentials.
- Obsidian vaults and its Electron profile.
- Browser profiles, GNS3 projects, documents, downloads, and application data.
- MPD databases/state, MAME NVRAM/save states, and Pharo recorder state.
- The detached LUKS header and other cryptographic recovery material.
- Generated themes, cursor binaries, Yazi plugins, and Yazi flavors.

Avoid absolute symlinks inside `stow/`.
