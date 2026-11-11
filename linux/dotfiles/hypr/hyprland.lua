-- https://wiki.hypr.land/Configuring/Start/

-- Home Manager links these modules from the Nix store, and Hyprland resolves
-- the symlink before setting package.path. Search the live config directory
-- first so the mutable, Noctalia-generated noctalia.lua is still found.
local home = os.getenv("HOME")
local config_dir = (os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")) .. "/hypr"
package.path = config_dir .. "/?.lua;" .. package.path

require("env")
require("monitors")
require("looks")
require("layout")
require("input")
require("keybindings")
require("rules")
require("workspaces")
require("autostart")

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
		focus_on_activate = true, -- Honor user-initiated activation requests, such as notification clicks
		middle_click_paste = false,
	},
})

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- For Noctalia Color templates
local noctalia = require("noctalia")
noctalia.apply_theme()

local function with_alpha(color, alpha)
	return color:gsub("^rgb%((%x+)%)$", "rgba(%1" .. alpha .. ")")
end

hl.config({
	group = {
		groupbar = {
			-- Restored: Noctalia regen dropped this, but the pill look
			-- (gradient_rounding in looks.lua) needs it. Kept here so
			-- regenerating noctalia.lua won't lose it again.
			gradients = true,
			col = {
				active = with_alpha(noctalia.colors.secondary, "cc"),
				inactive = with_alpha(noctalia.colors.surface, "00"),
				locked_active = with_alpha(noctalia.colors.error, "cc"),
				locked_inactive = with_alpha(noctalia.colors.surface, "77"),
			},
		},
	},
})

-------------------------
----- LOCAL TESTING -----
-------------------------

-- Unmanaged scratch file for quick experiments without a Home Manager switch.
-- Loaded last so it can override anything above; move what sticks into the
-- Tolknix modules and delete the file.
local temp_config = home .. "/.hypr/temp.lua"
local temp_file = io.open(temp_config, "r")
if temp_file then
	temp_file:close()
	dofile(temp_config)
end
