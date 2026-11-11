-- Assign workspaces to monitors
for i = 1, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2", default = (i == 1), persistent = true })
	hl.workspace_rule({ workspace = tostring(i + 10), monitor = "DP-3", default = (i == 1), persistent = true })
end

-- Each monitor owns a "decade" of 10 workspaces: monitor 0 = 1-10,
-- monitor 1 = 11-20, etc.
local function navigate_workspace(direction)
	local mon = hl.get_active_monitor()
	if not mon or not mon.active_workspace then
		return
	end

	local current = mon.active_workspace.id
	local decade_start = math.floor((current - 1) / 10) * 10 + 1
	local offset = current - decade_start
	local delta = (direction == "up") and 1 or -1
	local target = decade_start + ((offset + delta) % 10)

	hl.dispatch(hl.dsp.focus({ workspace = target }))
end
local function move_window_navigate(direction, follow)
	local mon = hl.get_active_monitor()
	if not mon or not mon.active_workspace then
		return
	end

	local current = mon.active_workspace.id
	local decade_start = math.floor((current - 1) / 10) * 10 + 1
	local offset = current - decade_start
	local delta = (direction == "up") and 1 or -1
	local target = decade_start + ((offset + delta) % 10)

	if follow then
		hl.dispatch(hl.dsp.window.move({ workspace = target }))
	else
		hl.dispatch(hl.dsp.exec_raw("movetoworkspacesilent " .. target))
	end
end

-- Detach the active window from its group, then move only that window to the
-- next empty workspace on the active monitor.
local function move_active_window_to_next_empty_workspace()
	hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
	hl.dispatch(hl.dsp.window.move({ workspace = "emptynm", follow = true }))
end

-- =============================================================================
-- BINDS
-- =============================================================================

local mainMod = "SUPER"
local moveMod = "CONTROL + SUPER"

-- W/F occupy the Page Up/Page Down positions from the Nav layer.
hl.bind(mainMod .. " + W", function()
	navigate_workspace("down")
end)
hl.bind(mainMod .. " + F", function()
	navigate_workspace("up")
end)
hl.bind(mainMod .. " + B", hl.dsp.focus({ workspace = "emptynm" }))
hl.bind(moveMod .. " + W", function()
	move_window_navigate("down", true)
end)
hl.bind(moveMod .. " + F", function()
	move_window_navigate("up", true)
end)
hl.bind(moveMod .. " + B", function()
	move_active_window_to_next_empty_workspace()
end)
