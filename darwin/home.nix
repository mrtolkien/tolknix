{ lib, ... }:

{
  # macOS-specific home-manager configuration
  # Imports common config and adds macOS-specific overrides

  imports = [
    ../common/home.nix
    ./packages.nix
  ];

  home = {
    # User identity (macOS)
    username = "garymialaret";
    homeDirectory = "/Users/garymialaret";

    file = {
      # AeroSpace scripts
      "scripts/aerospace_horizontal.sh".source = ./scripts/aerospace_horizontal.sh;
      "scripts/aerospace_reset.sh".source = ./scripts/aerospace_reset.sh;
    };
  };

  # macOS-specific dotfiles
  xdg.configFile."ghostty/darwin.conf".source = ./dotfiles/ghostty/darwin.conf;

  # macOS-specific program overrides
  programs = {
    fish = {
      shellAbbrs = {
        f = "open ."; # Open in Finder
        v = "y '/Users/garymialaret/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vaulki'"; # Obsidian vault
      };

      shellInit = lib.mkAfter ''
        # macOS-specific PATHs
        fish_add_path /opt/homebrew/bin # brew
        fish_add_path ~/Development/flutter/bin
        fish_add_path /Users/garymialaret/.fvm_flutter/bin
      '';
    };

    # AeroSpace window manager (macOS-only)
    aerospace = {
      enable = true;
      launchd.enable = true;
      settings = builtins.fromTOML (builtins.readFile ./dotfiles/aerospace.toml);
    };
  };
}
