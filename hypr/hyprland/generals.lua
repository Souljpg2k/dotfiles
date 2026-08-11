hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 5,
		border_size = 1,

		col = {
			active_border = { colors = { "rgba(1a1a1aee)" } },
			inactive_border = "rgba(1a1a1aee)",
		},

		resize_on_border = true,
		allow_tearing = true,
		layout = "dwindle",
	},

	decoration = {
		rounding = 18,
		rounding_power = 3,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			xray = true,
			new_optimizations = true,
			size = 8,
			passes = 3,
			brightness = 1,
			vibrancy = 0.1696,
		},
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
		smart_split = true,
		precise_mouse_move = true,
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
	},
})