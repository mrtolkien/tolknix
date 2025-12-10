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

  # Data tools
  jq
  # sqlite
  # yq
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
