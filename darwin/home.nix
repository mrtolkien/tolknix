{ config, pkgs, lib, ... }:

{
  # macOS-specific home-manager configuration
  # This extends the common configuration with macOS-specific settings

  # Home Manager state version
  home.stateVersion = "24.11";

  # Allow unfree packages (needed for unrar)
  nixpkgs.config.allowUnfree = true;

  # Import shared configurations
  programs = { } // import ../common/home-manager.nix { inherit config pkgs lib; };

  # macOS-specific program overrides
  programs.fish.shellAbbrs = lib.mkMerge [
    # Keep shared abbreviations from common/home-manager.nix
    (builtins.head (builtins.attrValues (import ../common/home-manager.nix { inherit config pkgs lib; }))).shellAbbrs or {}
    # Add macOS-specific abbreviations
    {
      f = "open .";  # Open in Finder
      v = "y '/Users/tolki/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vaulki'";  # Obsidian vault
    }
  ];

  programs.fish.shellInit = lib.mkAfter ''
    # macOS-specific PATHs
    fish_add_path /opt/homebrew/bin # brew
    fish_add_path ~/Development/flutter/bin
    fish_add_path /Users/tolki/.fvm_flutter/bin
  '';

  # AeroSpace window manager (macOS-only)
  programs.aerospace = {
    enable = true;
    userSettings = builtins.fromTOML (builtins.readFile ./dotfiles/aerospace.toml);
  };

  # Install packages: shared + macOS-specific
  home.packages = (pkgs.callPackage ../common/packages.nix { })
    ++ (pkgs.callPackage ./packages.nix { });

  # Dotfiles and scripts
  home.file = {
    # Shared configs
    ".config/lsd/config.yaml".source = ../common/dotfiles/lsd.yaml;
    ".config/ghostty/config".source = ../common/dotfiles/ghostty.conf;
    ".config/ghostty/cursor_blaze.glsl".source = ../common/dotfiles/cursor_blaze.glsl;
    ".config/ghostty/cursor_trail.glsl".source = ../common/dotfiles/cursor_trail.glsl;

    # macOS-specific configs
    ".config/ghostty/darwin.conf".source = ./dotfiles/ghostty-darwin.conf;
    "Library/Application Support/lazygit/config.yml".source = ../common/dotfiles/lazygit.yml;

    # AeroSpace scripts
    "scripts/aerospace_horizontal.sh".source = ./scripts/aerospace_horizontal.sh;
    "scripts/aerospace_reset.sh".source = ./scripts/aerospace_reset.sh;
  };
}
