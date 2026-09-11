hl.config({ ecosystem = { enforce_permissions = true } })

hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/wf-recorder", type = "screencopy", mode = "allow" })
