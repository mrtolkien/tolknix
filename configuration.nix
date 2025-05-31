{ pkgs, ... }:

{

  # Necessary for using flakes on this system.
  nix.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 23; Minute = 0; };
    options = "--delete-older-than 30d";
  };

  # Enable fonts dir
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  # TODO services.karabiner-elements.enable = true;

  users.users.tolki = {
    name = "tolki";
    home = "/Users/tolki";
    shell = pkgs.fish;
  };

  system = {
    primaryUser = "tolki";
    stateVersion = 4;

    # MacOS system configuration
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleKeyboardUIMode = 3;

        KeyRepeat = 1;

        InitialKeyRepeat = 12;
      };

      dock = {
        autohide = true;
        show-recents = true;
        showhidden = true;
        launchanim = true;
        orientation = "left";
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
      };

      trackpad = {
        TrackpadThreeFingerDrag = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
    };
  };

}
