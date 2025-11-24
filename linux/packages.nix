{ pkgs }:

# Linux-specific packages
with pkgs; [
  # Home manager itself (so the command is always available)
  home-manager
  waybar
  gearlever # AppImage manager
  # TUI managers
  bluetui
  pulsemixer
]
