{ config, pkgs, lib, ags, astal, ... }:

{
  # Linux-specific home-manager configuration
  # Imports common config and adds Linux-specific overrides

  imports = [ ../common/home-manager.nix ];

  # User identity
  home.username = "tolki";
  home.homeDirectory = "/home/tolki";

  # Fonts
  fonts.fontconfig.enable = true;

  # Japanese locale for date/time formats
  home.language = {
    base = "en_GB.UTF-8";           # Overall locale
    time = "ja_JP.UTF-8";            # Japanese date/time formats
    numeric = "ja_JP.UTF-8";         # Japanese number formats
    monetary = "ja_JP.UTF-8";        # Japanese currency formats
    measurement = "ja_JP.UTF-8";     # Metric system
  };

  # Japanese IME (fcitx5 with mozc)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # Environment variables for fcitx5 on Wayland/Hyprland
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus"; # For some apps like Ghostty
  };

  # Linux-specific packages
  home.packages = (pkgs.callPackage ./packages.nix { }) ++
    (pkgs.callPackage ./packages_hypr.nix { }) ++
        (with pkgs; [
    # Nerd Fonts (same as macOS)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ]);

  # Linux-specific dotfiles
  home.file.".config/xkb-custom-macos".source = ./dotfiles/xkb-custom-macos;

  # AGS widget system
  programs.ags = {
    enable = true;
    configDir = null; # Manage config manually in ~/.config/ags for now
    extraPackages = (with pkgs; [
      libdbusmenu-gtk3
    ]) ++ (with ags.packages.${pkgs.stdenv.hostPlatform.system}; [
      # Astal service libraries for bar widgets (using Hyprland native IPC instead of AstalHyprland)
      astal4      # Core Astal library
      tray        # System tray
      network     # Network status
      bluetooth   # Bluetooth status
      wireplumber # Audio control (WirePlumber)
    ]);
  };

  # Activation script to install keyboard layout system-wide
  # This requires sudo, so it will prompt during home-manager switch
  home.activation.installKeyboardLayout = lib.hm.dag.entryAfter ["writeBoundary"] ''
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
}
