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
  lazygit
  helix
  pre-commit
  bacon

  # Build and deploy
  # docker
  # docker-compose
  awscli2
  gh
  git-open

  # Data
  postgresql_17
  dbmate

  # Nix
  nil
  nixpkgs-fmt

  # Rust
  cargo-lambda
  rustup

  # Go
  go

  # Flutter
  cocoapods

  # CPP
  cmake

  # Javascript and Typescript
  nodePackages.nodemon
  nodePackages.npm # globally install npm
  nodePackages.pnpm # globally install npm
  nodejs
  deno
  yarn

  # AI
  ollama

  # Encryption and security tools
  age
]
