---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us_macos",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_delay = 200,
		repeat_rate = 40,

		follow_mouse = 0,
		float_switch_override_focus = 0,

		sensitivity = 0, -- handled in solaar

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.5,
		},
	},

	cursor = { hide_on_key_press = true },
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "keychron-keychron-nape-pro-mouse",
	accel_profile = "adaptive",
	sensitivity = -1,
})
