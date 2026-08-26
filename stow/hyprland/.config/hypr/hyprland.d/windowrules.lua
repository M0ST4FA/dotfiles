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
	match = { class = "^WebApp.*|firefox" },
	workspace = "2 silent",
})

hl.window_rule({
	match = { class = "qemu|mame|Waydroid|blender" },
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
