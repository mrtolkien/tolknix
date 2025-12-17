{ pkgs, lib, ... }:

{
  # Linux-specific home-manager configuration
  # Imports common config and adds Linux-specific overrides

  imports = [ ../common/home-manager.nix ];
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

    # Environment variables for fcitx5 on Wayland/Hyprland
    sessionVariables = {
      # Explicitly unset GTK_IM_MODULE to use native Wayland input method protocol
      # Use mkForce to override the fcitx5 module's default
      GTK_IM_MODULE = lib.mkForce "";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      GLFW_IM_MODULE = "ibus"; # For some apps like Ghostty
    };

    # Linux-specific packages
    packages = (pkgs.callPackage ./packages.nix { })
      ++ (with pkgs; [ monaspace ]);

    # Linux-specific dotfiles
    file.".config/xkb-custom-macos".source = ./dotfiles/xkb-custom-macos;

    # Activation script to install keyboard layout system-wide
    # This requires sudo, so it will prompt during home-manager switch
    activation.installKeyboardLayout =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        LAYOUT_SRC="$HOME/.config/xkb-custom-macos"
        LAYOUT_DEST="/usr/share/X11/xkb/symbols/us_macos"

        if [ -f "$LAYOUT_SRC" ]; then
          if ! diff -q "$LAYOUT_SRC" "$LAYOUT_DEST" >/dev/null 2>&1; then
            echo "Installing custom keyboard layout (requires sudo)..."
            if sudo cp "$LAYOUT_SRC" "$LAYOUT_DEST"; then
              echo "✓ Keyboard layout installed to $LAYOUT_DEST"
              echo "  Use 'kb_layout = us_macos' in Hyprland config"
            else
              echo "⚠ Failed to install keyboard layout (sudo required)"
            fi
          fi
        fi
      '';
  };

  # Fonts
  fonts.fontconfig.enable = true;

  # Japanese IME (fcitx5 with mozc)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
  };

  # home-manager managed programs
  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
    };
    vicinae = {
      enable = true;
      systemd.enable = true;
    };
    hyprlock.enable = true;
    hyprshot.enable = true;
  };

  services = {
    hypridle.enable = true;
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "/home/tolki/wallpapers/favorites/5g22q5.png"
          "/home/tolki/wallpapers/favorites/lqx1d2.jpg"
        ];

        wallpaper = [
          "DP-2,/home/tolki/wallpapers/favorites/5g22q5.png"
          "HDMI-A-1,/home/tolki/wallpapers/favorites/lqx1d2.jpg"
        ];
      };
    };
    swaync.enable = true;
    hyprpolkitagent.enable = true;
  };
  systemd = {
    user = {

      # Hyprland session target
      # Start with: systemctl --user start hyprland-session.target
      targets.hyprland-session.Unit = {
        Description = "Hyprland compositor session";
        Documentation = [ "man:systemd.special(7)" ];
        BindsTo = [ "graphical-session.target" ];
        Wants = [ "graphical-session-pre.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      # Automatic garbage collection (matching macOS config)
      services.nix-gc = {
        Unit = { Description = "Nix Garbage Collector"; };
        Service = {
          Type = "oneshot";
          ExecStart =
            "${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 30d";
        };
      };

      timers.nix-gc = {
        Unit = { Description = "Nix Garbage Collection Timer"; };
        Timer = {
          OnCalendar = "Sun *-*-* 23:00:00";
          Persistent = true;
        };
        Install = { WantedBy = [ "timers.target" ]; };
      };
    };
  };
}
