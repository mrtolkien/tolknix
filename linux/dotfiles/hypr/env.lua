-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("LC_TIME", "ja_JP.UTF-8")
hl.env("HYPRCURSOR_SIZE", "12")

hl.env("TERMINAL", "ghostty")
hl.env("EDITOR", "nvim")

-- Wayland/Electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("ELECTRON_FORCE_IS_PACKAGED", "true")

-- Qt/KDE theming
-- DEPENDS: qt5/qt6, plasma-integration
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "plasma-")

-- Dark mode preferences
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")
