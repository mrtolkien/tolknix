{ pkgs, ... }:

{
  # Linux home-manager entry point: shared config plus Linux-only modules

  imports = [
    ../common/home.nix
    ./packages.nix
    ./desktop.nix
  ];

  home = {
    # User identity
    username = "tolki";
    homeDirectory = "/home/tolki";

    # Japanese locale for date/time formats
    language = {
      base = "en_GB.UTF-8"; # Overall locale
      time = "ja_JP.UTF-8"; # Japanese date/time formats
      numeric = "ja_JP.UTF-8"; # Japanese number formats
      monetary = "ja_JP.UTF-8"; # Japanese currency formats
      measurement = "ja_JP.UTF-8"; # Metric system
    };
  };

  # Automatic garbage collection
  systemd.user = {
    services.nix-gc = {
      Unit.Description = "Nix Garbage Collector";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
      };
    };

    timers.nix-gc = {
      Unit.Description = "Nix Garbage Collection Timer";
      Timer = {
        OnCalendar = "Sun *-*-* 23:00:00";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
