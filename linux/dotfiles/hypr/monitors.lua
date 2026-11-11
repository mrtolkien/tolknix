------------------
---- MONITORS AND SCALING ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-2",
	mode = "preferred",
	position = "0x0",
	scale = "auto",
})

hl.monitor({
	output = "DP-3",
	mode = "preferred",
	position = "2560x-539",
	scale = "auto",
	transform = 3,
})

-- unscale XWayland
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- toolkit-specific scale
hl.env("GDK_SCALE", "1.5")
hl.env("XCURSOR_SIZE", "26")
