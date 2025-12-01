{ pkgs }:

# Linux-specific packages
with pkgs; [
  # Home manager itself (so the command is always available)
  home-manager
  gearlever # AppImage manager
  # TUI managers
  bluetui
  pulsemixer
  # GUI stuff
  networkmanagerapplet # Network manager system tray
  blueman # Bluetooth manager system tray
]
