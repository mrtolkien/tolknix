{ pkgs, lib, ... }:

let
  editor = [ "nvim-ghostty.desktop" ];
  browser = [ "firefox.desktop" ];
  imageViewer = [ "org.gnome.Loupe.desktop" ];
  todoist = [ "com.todoist.Todoist.desktop" ];
in
{
  # Linux desktop session: Hyprland config, shell, input method and file
  # associations. Hyprland itself is installed by pacman.

  home.sessionVariables = {
    # fcitx5 on Wayland/Hyprland. GTK_IM_MODULE is explicitly emptied to use
    # the native Wayland input method protocol; mkForce overrides the fcitx5
    # module's default.
    GTK_IM_MODULE = lib.mkForce "";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus"; # For some apps like Ghostty
    FILE_MANAGER = "thunar";
  };

  xdg = {
    # dotfiles/ mirrors the layout of ~/.config
    configFile = {
      # libxkbcommon (and therefore Hyprland) loads per-user layouts from here.
      # Hyprland selects this layout with: kb_layout = us_macos
      "xkb/symbols/us_macos".source = ./dotfiles/xkb/symbols/us_macos;

      # Hyprland's Lua configuration. Linked file by file so the directory
      # stays writable: Noctalia regenerates ~/.config/hypr/noctalia.lua there,
      # and hyprland.lua also loads ~/.hypr/temp.lua when present for quick
      # tests.
      "hypr" = {
        source = ./dotfiles/hypr;
        recursive = true;
      };

      # Replace only paru's stale service-enablement symlink; this is not an
      # app settings file, and must point at the Home Manager unit after
      # migration.
      "systemd/user/graphical-session.target.wants/vicinae.service".force = true;
    };

    # Desktop entry for opening files in nvim via ghostty
    desktopEntries.nvim-ghostty = {
      name = "Neovim (Ghostty)";
      genericName = "Text Editor";
      exec = "ghostty -e nvim %F";
      terminal = false;
      categories = [
        "Utility"
        "TextEditor"
      ];
      mimeType = [
        "text/plain"
        "text/x-script"
        "application/x-shellscript"
      ];
    };

    # XDG MIME associations
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = browser;
        # Text files → nvim in ghostty
        "text/plain" = editor;
        "text/x-script" = editor;
        "application/x-shellscript" = editor;
        "text/x-python" = editor;
        "text/x-csrc" = editor;
        "text/x-chdr" = editor;
        "text/x-java" = editor;
        "text/x-makefile" = editor;
        "text/x-markdown" = editor;
        "text/xml" = editor;
        "application/json" = editor;
        "application/x-yaml" = editor;
        "application/toml" = editor;
        # Web
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        # Images
        "image/png" = imageViewer;
        "image/jpeg" = imageViewer;
        "image/gif" = imageViewer;
        "image/webp" = imageViewer;
        "image/svg+xml" = imageViewer;
        # Scheme handlers
        "x-scheme-handler/terminal" = [ "Ghostty.desktop" ];
        "x-scheme-handler/todoist" = todoist;
        "x-scheme-handler/com.todoist" = todoist;
        # File manager
        "inode/directory" = [ "thunar.desktop" ];
      };
    };
  };

  fonts.fontconfig.enable = true;

  # Make Nix-installed graphical applications work on non-NixOS hosts. The
  # default Mesa driver set supports AMD, Intel, and Nouveau without tying this
  # configuration to the currently installed GPU.
  targets.genericLinux.gpu.enable = true;

  # Japanese IME (fcitx5 with mozc)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  programs = {
    # Noctalia is started by Hyprland's autostart. These settings are the
    # declarative base layer; changes made in the settings UI are still saved
    # to ~/.local/state/noctalia/settings.toml and win over this file.
    #
    # To keep UI changes, from the repository root:
    #   noctalia config export > linux/dotfiles/noctalia/config.toml
    #   home-manager switch --flake .#tolki@cachyos
    #   rm ~/.local/state/noctalia/settings.toml
    #
    # The rm clears the UI overrides, which would otherwise keep shadowing
    # the same keys here.
    noctalia = {
      enable = true;
      settings = ./dotfiles/noctalia/config.toml;
    };

    # Keep Vicinae's existing mutable config; Home Manager installs the package
    # and owns the daemon service without generating a settings file.
    vicinae = {
      enable = true;
      # Leave the existing browser native-messaging manifests untouched.
      enableFirefoxIntegration = false;
      systemd.enable = true;
    };

    hyprshot.enable = true;
  };

  # Hyprland session target
  # Start with: systemctl --user start hyprland-session.target
  systemd.user.targets.hyprland-session.Unit = {
    Description = "Hyprland compositor session";
    Documentation = [ "man:systemd.special(7)" ];
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };
}
