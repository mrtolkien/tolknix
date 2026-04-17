{ config, pkgs, lib, ... }:

{
  # macOS-specific home-manager configuration
  # Imports common config and adds macOS-specific overrides

  imports = [ ../common/home-manager.nix ];

  # User identity (macOS)
  home.username = "garymialaret";
  home.homeDirectory = "/Users/garymialaret";

  # macOS-specific packages
  home.packages = pkgs.callPackage ./packages.nix { };

  # macOS-specific dotfiles
  home.file = {
    ".config/ghostty/darwin.conf".source = ./dotfiles/ghostty-darwin.conf;
    "Library/Application Support/lazygit/config.yml".source = ../common/dotfiles/lazygit.yml;

    # AeroSpace scripts
    "scripts/aerospace_horizontal.sh".source = ./scripts/aerospace_horizontal.sh;
    "scripts/aerospace_reset.sh".source = ./scripts/aerospace_reset.sh;
  };

  # macOS-specific program overrides
  programs.fish.shellAbbrs = {
    f = "open .";  # Open in Finder
    v = "y '/Users/garymialaret/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vaulki'";  # Obsidian vault
  };

  programs.fish.shellInit = lib.mkAfter ''
    # macOS-specific PATHs
    fish_add_path /opt/homebrew/bin # brew
    fish_add_path ~/Development/flutter/bin
    fish_add_path /Users/garymialaret/.fvm_flutter/bin
  '';

  # AeroSpace window manager (macOS-only)
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = builtins.fromTOML (builtins.readFile ./dotfiles/aerospace.toml);
  };
}
