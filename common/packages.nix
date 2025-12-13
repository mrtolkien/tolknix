{ pkgs }:

# Shared CLI tools and utilities for both macOS and Linux
with pkgs; [
  # File management (yazi, lsd managed via programs.* in home-manager.nix)
  # TODO: Review which can have shell integration w/ home manager
  fd
  ripgrep
  bat
  less
  tealdeer
  bacon
  broot

  # System utilities
  killall
  openssh
  wget
  zip
  unrar
  unzip
  btop
  nvtopPackages.full

  viu # Two tools for showing images in terminal, still WiP
  chafa

  # Data tools
  jq
  rclone
  croc

  # Documentation and publishing
  pandoc
  hugo

  # Git and version control
  gh
  git-open
  pre-commit

  # Build and deploy
  awscli2

  # Data
  postgresql_17

  # Programming languages
  cargo-lambda
  zig
  statix

  # CPP
  cmake
]
