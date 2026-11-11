--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ignore maximize requests from all apps
-- hl.window_rule({
-- 	name = "suppress-maximize-events",
-- 	match = { class = ".*" },
--
-- 	suppress_event = "maximize",
-- })

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.layer_rule({
	match = { namespace = "vicinae" },
	blur = true,
	no_anim = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
	},
	no_anim = true,
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

hl.window_rule({
	match = {
		class = "com.mitchellh.ghostty",
	},
	opacity = 0.98,
})

hl.window_rule({
	match = { class = "hermes" },
	opacity = 0.99,
})

hl.window_rule({
	match = { class = "Beeper" },
	opacity = 0.9,
	workspace = 11,
	group = "barred",
})

hl.window_rule({
	match = { class = "todoist" },
	opacity = 0.91,
	workspace = 11,
	group = "set",
})

hl.window_rule({
	match = { class = "^(discord|com\\.discordapp\\.Discord)$" },
	opacity = 0.95,
	workspace = 11,
	group = "set",
})

hl.window_rule({
	match = { class = "com.github.th-ch.youtube-music" },
	opacity = 0.95,
	workspace = 11,
	group = "set",
})
