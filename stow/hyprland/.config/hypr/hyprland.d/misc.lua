hl.config({
	opengl = {
		nvidia_anti_flicker = true,
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		animate_mouse_windowdragging = true,
		animate_manual_resizes = true,
		enable_swallow = false,
		-- swallow_regex = ".*"
	},
	ecosystem = {
		enforce_permissions = true,
		permission = {
			"/usr/bin/grim, screencopy, allow",
			"/usr/bin/flameshot, screencopy, allow",
			"/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow",
		},
	},
})
