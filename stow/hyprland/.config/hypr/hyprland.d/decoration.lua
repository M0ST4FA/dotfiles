hl.config({
	decoration = {
		rounding = 12,
		rounding_power = 4,
		active_opacity = 0.90,
		inactive_opacity = 0.85,

		shadow = {
			enabled = true,
			range = 30,
			render_power = 3,
			color = "rgba(00000055)",
		},

		motion_blur = {
			enabled = true,
			samples = 10,
		},

		wobble = {
			enabled = false,
		},

		blur = {
			enabled = true,
			-- variant = "heat_shimmer",
			variant = "prism",

			water = {
				damping = 0.8,
				duration = 12.0,
				radius = 10.0,
				speed = 5.0,
				strength = 20.0,
			},

			heat_shimmer = {
				speed = 4.0,
			},

			haze = {
				intensity = 0.4,
				iridescence = 0.8,
			},

			drops = {
				speed = 4.0,
			},

			aurora = {
				color1 = borderColor1,
				color2 = borderColor2,
				intensity = 0.5,
				speed = 5.0,
			},

			acrylic = {
				aberration = 0.25,
				bulb = 24.0,
				clarity = 0.1,
				refraction = 48.0,
				tint = borderColor1,
			},

			glass = {
				refraction = 14.0,
				roughness = 0.3,
				size = 100.0,
			},

			size = 5,
			passes = 3,
			vibrancy = 0.5,
			vibrancy_darkness = 0.1,
			ignore_opacity = false,
			brightness = 0.5,
			contrast = 1.0,
			noise = 0.05,
			xray = true,
			popups = true,
			new_optimizations = true,
		},
	},
})
