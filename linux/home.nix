{ config, pkgs, lib, ... }:

{
  # Linux-specific home-manager configuration
  # Imports common config and adds Linux-specific overrides

  imports = [ ../common/home-manager.nix ];

  # User identity
  home.username = "tolki";
  home.homeDirectory = "/home/tolki";

  # Linux-specific packages
  home.packages = pkgs.callPackage ./packages.nix { };

  # Linux-specific dotfiles
  home.file.".config/xkb-custom-macos".source = ./dotfiles/xkb-custom-macos;

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
