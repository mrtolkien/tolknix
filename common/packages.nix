{ pkgs }:

# Shared CLI tools and utilities for both macOS and Linux
with pkgs; [
  # Use programs.* in home-manager.nix for tools that need configuration or
  # shell integration; keep install-only tools in this package list.
  fd
  ripgrep
  bat
  less
  dragon-drop

  # System utilities
  killall
  openssh
  wget
  zip
  unrar
  unzip
  btop
  nvtopPackages.full
  bitwarden-cli

  chafa

  # Data tools
  jq
  hugo

  # Git and version control
  gh

  # Data
  postgresql_17

  # Programming languages
  statix

  # Candidates for removal; keep installed until their usage is confirmed.
  bacon
  broot
  todoist
  ttyd
  viu
  rclone
  croc
  pandoc
  git-open
  pre-commit
  awscli2
  cargo-lambda
  zig
  cmake
]
