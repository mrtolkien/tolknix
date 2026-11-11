-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("solaar --window=hide")
	hl.exec_cmd("noctalia")
	hl.exec_cmd("flatpak run com.todoist.Todoist")
	hl.exec_cmd("flatpak run com.discordapp.Discord")
	hl.exec_cmd("pear-desktop")
	hl.exec_cmd("beeper")
end)
