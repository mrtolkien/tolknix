local mainMod = "SUPER"
local moveMod = "CONTROL + SUPER"

-- Vicinae
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(
	"SUPER + CONTROL + ALT + SHIFT + Space",
	hl.dsp.exec_cmd("vicinae vicinae://launch/@akshay_k/store.raycast.vim-leader-key/leader-key")
)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind(
	mainMod .. " + SHIFT + A",
	hl.dsp.exec_cmd("vicinae vicinae://launch/@tolki/notifications-manager/notifications")
)

-- Programs
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.bind(
	mainMod .. " + Return",
	hl.dsp.exec_cmd(
		"gdbus call --session --dest com.mitchellh.ghostty --object-path /com/mitchellh/ghostty --method org.gtk.Actions.Activate new-window '[]' '[]'"
	)
)

-- TODO: Replace with noctalia screenshot once it supports screenshotting the active window
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprshot_menu.sh"))

-- TILING AND WINDOW MOVEMENT

-- OSEN forms a directional diamond on the physical keyboard.
local directions = {
	O = "up",
	S = "left",
	E = "down",
	N = "right",
}

for key, direction in pairs(directions) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
	hl.bind(moveMod .. " + " .. key, hl.dsp.window.move({ direction = direction, group_aware = true }))
end

-- Resize mode: Super + R, then OSEN; Escape/Enter returns to normal bindings.
local resizeHint = "RESIZE: O/E height | S/N width | Esc/Enter to exit"
local resizeNotification

-- A config reload must not leave a paused indicator from the previous config.
for _, notification in ipairs(hl.notification.get()) do
	if notification:get_text() == resizeHint then
		notification:dismiss()
	end
end

hl.on("keybinds.submap", function()
	if resizeNotification then
		resizeNotification:dismiss()
		resizeNotification = nil
	end
	if hl.get_current_submap() == "resize" then
		resizeNotification = hl.notification.create({ text = resizeHint, timeout = 5000, icon = "info" })
		resizeNotification:pause()
	end
end)

hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	local resizeSteps = {
		O = { x = 0, y = -50 },
		E = { x = 0, y = 50 },
		S = { x = -50, y = 0 },
		N = { x = 50, y = 0 },
	}
	for key, step in pairs(resizeSteps) do
		hl.bind(key, hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), {
			repeating = true,
			ignore_mods = true,
		})
	end
	for _, key in ipairs({ "Escape", "Return" }) do
		hl.bind(key, hl.dsp.submap("reset"), { ignore_mods = true })
	end
end)

hl.bind(mainMod .. " + A", hl.dsp.focus({ monitor = "+1" }))

-- GROUPS
hl.bind(mainMod .. " + C", hl.dsp.group.prev())
hl.bind(mainMod .. " + P", hl.dsp.group.next())
hl.bind(moveMod .. " + C", hl.dsp.group.move_window({ forward = false }))
hl.bind(moveMod .. " + P", hl.dsp.group.move_window())
hl.bind(mainMod .. " + minus", hl.dsp.group.toggle())

-- GENERIC FOCUS AND WINDOW MANAGEMENT
hl.bind(mainMod .. " + X", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + V", hl.dsp.window.fullscreen())

-- WORKSPACES ARE IN WORKSPACES.lua

-- DEFAULTS
-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- MEDIA
-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
