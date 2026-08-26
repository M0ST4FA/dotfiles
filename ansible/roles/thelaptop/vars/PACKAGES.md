# Package categories

Each package belongs to exactly one list in `packages/`. Classify it by the
reason this workstation installs it, not by every purpose the package could
possibly serve.

Use the first matching category in this order:

1. `dependencies`: an implementation, runtime, or workaround explicitly pinned
   for other packages; it is not installed for direct use.
2. `system`: the base OS, kernel, boot process, filesystems, console, and machine
   provisioning.
3. `hardware`: firmware and software that controls a physical device, power, or
   platform-specific hardware.
4. `networking`: network connectivity, time synchronization, and package mirrors.
5. `desktop_session`: graphical login, compositor, portals, session services,
   clipboard, and screenshots.
6. `terminal`: terminal emulators, shells, and general-purpose command-line tools.
7. `development`: editors, compilers, build tools, source control, and programming
   language tooling.
8. `virtualization`: virtual machines, containers, and guest environments.
9. `security`: defensive/offensive security tools, cryptography, and secrets.
10. `communication`: browsers, chat, and email clients or their direct helpers.
11. `media`: audio, video, image creation, and media controls.
12. `documents`: notes, handwriting, document viewers, OCR, and document metadata.
13. `appearance`: fonts, icons, themes, and toolkit appearance configuration.

When a package appears to fit more than one category, use its primary reason for
being explicitly installed. For example, `w3m` is under `communication` because
it renders HTML email for NeoMutt here, while `wget` is under `terminal` because
it is a general-purpose CLI utility. Do not list an ordinary transitive
dependency: pacman/paru will install it automatically.

Every file defines one variable named `packages_<filename>`. Register new
categories in `package_groups` in `vars/main.yml`; packages added to an existing
category need no task changes.

