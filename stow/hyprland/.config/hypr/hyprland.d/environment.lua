hl.env("AQ_DRM_DEVICES", "/dev/dri/igpu:/dev/dri/dgpu")
hl.env("HYPRCURSOR_SIZE", "32")
hl.env("SSH_AUTH_SOCK", "/run/user/1000/ssh-agent.socket")

hl.env("GRIMBLAST_EDITOR", "satty --filename")
hl.env("XWAYLAND_SCALE", "1")

hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_ENABLE_WAYLAND", "1")

hl.env("XCURSOR_PATH", "/home/m0st4fa/.icons:/home/m0st4fa/.local/share/icons:/usr/local/share/icons:/usr/share/icons")
hl.env("XCURSOR_THEME", "Nordic-cursors")
hl.env("XCURSOR_SIZE", "32")

hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("GDK_BACKEND", "wayland,x11")
