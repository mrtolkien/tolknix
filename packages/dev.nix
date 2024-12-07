{ pkgs }:

with pkgs; [
  # Text editors
  neovim
  helix

  # Development tools
  nil
  nixpkgs-fmt
  postgresql
  pre-commit
  dbmate
  cmake
  pandoc

  # Docker
  docker
  docker-compose

  # AI
  ollama

  # Security
  age

  # Other
  go
]
