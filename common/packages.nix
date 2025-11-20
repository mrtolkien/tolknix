{ pkgs }:

# Shared CLI tools and utilities for both macOS and Linux
with pkgs; [
  # Shell and prompt
  fish
  starship
  atuin
  zoxide
  carapace
  fzf
  direnv

  # File management
  yazi
  lsd
  fd
  ripgrep
  bat
  less
  tealdeer

  # System utilities
  killall
  neofetch
  openssh
  sqlite
  wget
  zip
  unrar
  unzip
  bottom

  # Data tools
  jq
  yq
  rclone

  # Documentation and publishing
  pandoc
  hugo

  # Editors
  helix
  neovim

  # Git and version control
  git
  gh
  lazygit
  pre-commit

  # Build and deploy
  awscli2
  # docker
  # docker-compose

  # Data
  postgresql_17
  dbmate

  # Nix development
  nil
  nixpkgs-fmt

  # Programming languages
  rustup
  cargo-lambda
  zig
  go
  nodejs_24
  deno

  # CPP
  cmake

  # Development tools
  bacon

  # AI
  ollama

  # Encryption and security
  age
]
