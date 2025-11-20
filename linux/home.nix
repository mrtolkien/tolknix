{ config, pkgs, lib, ... }:

{
  # Linux-specific home-manager configuration
  # This extends the common configuration with Linux-specific settings

  # Home Manager state version
  home.stateVersion = "24.11";

  # Allow unfree packages (needed for unrar)
  nixpkgs.config.allowUnfree = true;

  # Import shared configurations
  programs = { } // import ../common/home-manager.nix { inherit config pkgs lib; };

  # Install packages: shared + Linux-specific
  home.packages = (pkgs.callPackage ../common/packages.nix { })
    ++ (pkgs.callPackage ./packages.nix { });

  # Dotfiles
  home.file = {
    # Shared configs
    ".config/lsd/config.yaml".source = ../common/dotfiles/lsd.yaml;
    ".config/ghostty/config".source = ../common/dotfiles/ghostty.conf;
    ".config/ghostty/cursor_blaze.glsl".source = ../common/dotfiles/cursor_blaze.glsl;
    ".config/ghostty/cursor_trail.glsl".source = ../common/dotfiles/cursor_trail.glsl;
    ".config/lazygit/config.yml".source = ../common/dotfiles/lazygit.yml;

    # Linux-specific: keyboard layout source file
    ".config/xkb-custom-macos".source = ./dotfiles/xkb-custom-macos;

    # Hyprland configs - prepared but not active yet
    # Uncomment when ready to migrate Hyprland to nix management
    # ".config/hypr/nix-managed/README.md".text = ''
    #   This directory is managed by nix.
    #   To activate, source these configs from your main hyprland.conf
    # '';
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
