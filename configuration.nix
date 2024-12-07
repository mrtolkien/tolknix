{ pkgs, ... }:

{
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # services.karabiner-elements.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.gc = {
    user = "root";
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

  users.users.tolki = {
    name = "tolki";
    home = "/Users/tolki";
    shell = pkgs.zsh;
  };

  # MacOS specific configuration
  system = {
    stateVersion = 4;

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
      # remapCapsLockToControl = true;
    };
  };

}
