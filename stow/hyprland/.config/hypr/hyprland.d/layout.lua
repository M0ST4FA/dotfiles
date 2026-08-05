local colors = require("colors")

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 2,
		col = {
			active_border = { colors = { colors.borderColor1, colors.borderColor2 }, angle = 45 },
			inactive_border = colors.borderColorInactive,
		},
		resize_on_border = true,
		allow_tearing = true,
		layout = "scrolling",
		no_focus_fallback = true,
		snap = {
			enabled = true,
			respect_gaps = true,
		},
		modal_parent_blocking = false,
	},
	group = {
		col = {
			border_active = { colors = { colors.groupBorderColor1, colors.groupBorderColor2 }, angle = 45 },
			border_inactive = {
				colors = { colors.groupBorderColorInactive1, colors.groupBorderColorInactive2 },
				angle = 45,
			},
		},
		groupbar = {
			col = {
				active = colors.groupIndicatorColor,
				inactive = colors.groupIndicatorColorInactive,
			},
			render_titles = false,
			height = 0,
			rounding = 5,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	scrolling = {
		column_width = 0.8,
		focus_fit_method = 1,
		direction = "down",
	},
})
