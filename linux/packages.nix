{ pkgs }:

# Linux-specific packages
with pkgs; [
  # Logitech device manager
  solaar

  # Home manager itself (so the command is always available)
  home-manager
]
