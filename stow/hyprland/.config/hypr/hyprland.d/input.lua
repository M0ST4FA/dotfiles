hl.config({
	input = {
		kb_layout = "us,ara,es",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:alt_shift_toggle,keypad:pointerkeys",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.3,
		},
		tablet = {
			transform = 0,
			output = "DP-1",
		},
	},
	cursor = {
		no_warps = true,
	},
	device = {
		{
			name = "razer-razer-deathadder-v2",
			scroll_factor = 0.7,
		},
		{
			name = "wacom-one-by-wacom-m-pen",
			transform = 0,
			sensitivity = 5,
		},
		{
			name = "mousebuds-pro-mouse",
			scroll_factor = 0.3,
			sensitivity = 1,
		},
	},
})
