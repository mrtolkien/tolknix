{ pkgs, ... }:

{
  nix = {

    # Necessary for using flakes on this system.
    enable = false;
    # settings.experimental-features = "nix-command flakes";
    # gc = {
      # automatic = true;
      # interval = {
        # Weekday = 0;
        # Hour = 23;
        # Minute = 0;
      # };
      # options = "--delete-older-than 30d";
    # };
  };

  # Enable fonts dir
  fonts.packages = with pkgs; [ monaspace ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  # TODO: services.karabiner-elements.enable = true;

  users.knownUsers = [ "garymialaret" ];
  users.users.garymialaret = {
    name = "garymialaret";
    uid = 501;
    gid = 20;
    home = "/Users/garymialaret";
    shell = pkgs.fish;
  };

  system = {
    primaryUser = "garymialaret";
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

      trackpad = { TrackpadThreeFingerDrag = false; };
    };

    keyboard = { enableKeyMapping = true; };
  };

}
