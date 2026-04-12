{ pkgs }:

# Linux-specific packages
with pkgs; [
  # Home manager itself (so the command is always available)
  home-manager
  # gearlever # AppImage manager - disabled: dwarfs build failure in nixpkgs
  # TUI managers
  bluetui
  pulsemixer
  # GUI stuff
  networkmanagerapplet # Network manager system tray
  blueman # Bluetooth manager system tray
  # File manager
  thunar
  thunar-volman # Removable media management
  thunar-archive-plugin
  tumbler # Thumbnail service
  ffmpegthumbnailer # Video thumbnails
  loupe # Image viewer
]
