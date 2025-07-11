{ pkgs }:

with pkgs; [
  # System utilities
  yazi
  killall
  neofetch
  openssh
  sqlite
  wget
  zip
  unrar
  unzip
  bottom
  fd
  jq
  yq
  ripgrep
  bat
  less
  tealdeer
  rclone

  # CLI tools
  pandoc
  hugo

  # Code
  helix
  pre-commit
  bacon

  # Build and deploy
  # docker
  # docker-compose
  awscli2
  gh
  # git-open  # Temporarily disabled due to hostname-debian dependency issue

  # Data
  postgresql_17
  dbmate

  # Nix
  nil
  nixpkgs-fmt

  # Rust
  cargo-lambda
  rustup
  zig

  # Go
  go

  # Flutter
  cocoapods

  # CPP
  cmake

  # Javascript and Typescript
  nodejs_24
  deno

  # AI
  ollama

  # Encryption and security tools
  age
]
