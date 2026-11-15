hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		float = true,
		fullscreen = false,
		xwayland = true,
	},
	no_focus = true,
})

hl.window_rule({
	match = { title = "LED" },
	float = true,
})

hl.window_rule({
	match = { class = "^WebApp.*|firefox|zen" },
	workspace = "2 silent",
})

hl.window_rule({
	match = { class = "qemu|mame|Waydroid|blender|com.freerdp.client.sdl3" },
	workspace = "3 silent",
})

hl.window_rule({
	match = { title = "btop|Telegram" },
	workspace = "4 silent",
})

hl.window_rule({
	match = { class = "^WebApp.*|mame|qemu|kitty|Waydroid|blender" },
	opaque = true,
})

hl.window_rule({
	match = { class = "mame|qemu|Waydroid" },
	maximize = true,
	size = "1280 800",
})

hl.window_rule({
	match = { class = "org.pwmt.zathura|com.github.flxzt.rnote" },
	opaque = true,
})

-- Portal dialogs must stay visible above the scrolling workspace layout.
hl.window_rule({
	name = "termfilechooser-dialog",
	match = { class = "^termfilechooser$" },
	float = true,
	size = "80% 80%",
	center = true,
	opaque = true,
})
