hl.config({
	input = {
		kb_layout = "us,th",
		kb_variant = "",
		kb_model = "",
		kb_options = "grp:win_space_toggle",
		kb_rules = "",

		repeat_rate = 50,
		repeat_delay = 200,
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},

	binds = {
        scroll_event_delay = 0,
        hide_special_on_workspace_change = true
    },

	cursor = {
        zoom_factor = 1,
        zoom_rigid = false,
        zoom_disable_aa = true,
        hotspot_padding = 1
    },

	xwayland = {
        force_zero_scaling = true
    }
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})