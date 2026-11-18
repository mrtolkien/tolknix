{ config, ... }:

{
  # Vicinae launcher: daemon, declarative settings and the Leader Key extension.

  programs.vicinae = {
    enable = true;
    # Leave the existing browser native-messaging manifests untouched.
    enableFirefoxIntegration = false;
    systemd.enable = true;

    # Settings below are applied as overrides through VICINAE_OVERRIDES.
    # ~/.config/vicinae/settings.json stays writable, so the GUI still works,
    # but a GUI change to a key declared here is shadowed by this file.
    mutableSettings = true;
    settings = {
      close_on_focus_loss = false;
      tray.enabled = false;
      font.normal.family = "Adwaita Sans";
      theme.dark.name = "catppuccin-mocha";
      launcher_window.opacity = 0.9;

      providers = {
        "@jomifepe/store.raycast.bitwarden".preferences = {
          cliPath = "${config.home.homeDirectory}/.nix-profile/bin/bw";
          fetchFavicons = true;
          repromptIgnoreDuration = "3600000";
          serverUrl = "";
          shouldCacheVaultItems = true;
          syncOnLaunch = true;
          windowActionOnCopy = "close";
        };

        "@tolki/notifications-manager" = {
          enabled = true;
          preferences = {
            backend = "noctalia";
            history-path = "~/.local/state/noctalia/notification_history.json";
          };
        };

        applications.entrypoints = {
          "freecad_weekly-2026.07.22-linux-x86_64".alias = "FreeCAD DAILY";
          "org.freecad.FreeCAD".alias = "FreeCAD stable";
        };

        files.preferences.excludedIndexingPaths = [
          "${config.home.homeDirectory}/Development/ai/uraeda/target"
          "${config.home.homeDirectory}/Development/ai/uraeda/.worktrees"
          "${config.home.homeDirectory}/Development/ai/uraeda-eval"
        ];
      };
    };
  };

  # Raycast "Vim Leader Key" extension, built from raycast/extensions.
  # It is linked under the directory name the Vicinae store used, so its
  # provider id and its LocalStorage (the shortcut tree) stay the same. The
  # extensions option would name the directory "vim-leader-key" instead.
  #
  # The shortcut tree lives in Vicinae's database, not in a file. The managed
  # copy is dotfiles/vicinae/leader-key.json; load it with the extension's
  # "Import Config" command, and refresh it with "Export Config".
  xdg.dataFile."vicinae/extensions/store.raycast.vim-leader-key".source =
    (config.lib.vicinae.mkRayCastExtension {
      name = "vim-leader-key";
      rev = "f309fd3b523b6332f41f165daa3b68209826987d";
      sha256 = "sha256-fdcfp1Ae3dKdTMEKyJNuaF6YoJbXsfojsHj4jAu6Px0=";
    }).overrideAttrs
      {
        # This extension's build script writes to ./dist (-o dist) instead of
        # Raycast's default output directory, which the helper's installPhase
        # expects.
        installPhase = ''
          runHook preInstall

          mkdir -p $out
          cp -r dist/* $out/

          runHook postInstall
        '';
      };
}
