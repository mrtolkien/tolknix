{ pkgs }:

# Shared CLI tools and utilities for both macOS and Linux
with pkgs; [
  # File management (yazi, lsd managed via programs.* in home-manager.nix)
  fd
  ripgrep
  bat
  less
  tealdeer
  broot

  # System utilities
  killall
  neofetch
  openssh
  wget
  zip
  unrar
  unzip

  # Data tools
  jq
  # sqlite
  # yq
  rclone

  # Documentation and publishing
  pandoc
  hugo

  # Git and version control
  gh
  pre-commit

  # Build and deploy
  awscli2
  # docker
  # docker-compose

  # Data
  postgresql_17
  # dbmate

  # Nix development
  # nil
  # nixpkgs-fmt

  # Programming languages
  cargo-lambda
  zig
  go
  # nodejs_24
  # deno

  # CPP
  cmake

  # Development tools
  bacon

  # AI
  # ollama  # Temporarily disabled - build fails in nixpkgs-unstable 0.12.11

  # Encryption and security
  # age
]
