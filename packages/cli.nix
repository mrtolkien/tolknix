{ pkgs }:

with pkgs; [
  # System utilities
  coreutils
  killall
  openssh
  wget
  zip
  unrar
  unzip

  # Shell utilities
  zsh
  neofetch
  starship
  atuin

  # Text and terminal utilities
  bottom
  ripgrep
  fd
  bat
  jq
  yq
  less
  tealdeer
  chezmoi # TODO Remove
  yazi

  # Cloud and Git tools
  lazygit
  gh
  awscli2
  git-open
]
