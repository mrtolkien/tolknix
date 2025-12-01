
{ pkgs }:

# Hyprland packages
with pkgs; [
  waybar
  hypridle
  hyprlock
  hyprpaper
  hyprshot
  vicinae
  brightnessctl
  swaynotificationcenter # Notification daemon with waybar integration
  networkmanagerapplet # Network manager system tray
  blueman # Bluetooth manager system tray
]
