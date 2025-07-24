# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### Initial Setup

```bash
# First time installation
nix run nix-darwin -- switch --flake ~/.config/nix#mbp
```

### Regular Operations

```bash
# Apply configuration changes
darwin-rebuild switch --flake ~/.config/nix#mbp

# Build configuration without applying (for testing)
darwin-rebuild build --flake ~/.config/nix#mbp

# Format Nix files
nixpkgs-fmt *.nix
```

### Nix Garbage Collection

Automatic garbage collection is configured to run weekly, but can be triggered manually:

```bash
nix-collect-garbage --delete-older-than 30d
```

## Architecture Overview

This is a **nix-darwin** configuration for macOS that manages both system-level and user-level configurations using:

- **flake.nix**: Main entry point defining the Darwin system configuration for "mbp" host
- **configuration.nix**: System-level Darwin configuration (fonts, system defaults, user setup)
- **home.nix**: Home Manager entry point that imports user programs and packages
- **home-manager.nix**: User application configurations (fish, git, helix, etc.)
- **packages.nix**: List of packages to install via Home Manager

### Key Configuration Patterns

1. **Dotfile Management**: Configuration files are stored in `dotfiles/` and linked via `home.file` in home.nix
2. **Modular Structure**: Programs are configured in home-manager.nix, packages listed separately in packages.nix
3. **TOML Integration**: Editor configs (helix, starship, aerospace) use `builtins.fromTOML` to read external files

### User Environment

- **Shell**: Fish with custom abbreviations and environment setup
- **Editor**: Helix as primary editor, Neovim as fallback
- **Terminal Tools**: yazi (file manager), lazygit, starship prompt, zellij multiplexer
- **Window Manager**: AeroSpace for window management
- **Development**: Rust, Go, Flutter, Node.js, Python toolchains included

### System Defaults

macOS system preferences are managed declaratively in configuration.nix:

- Dock: Hidden, left-oriented, 48px tiles
- Finder: Show all extensions, list view
- Keyboard: Fast key repeat, no press-and-hold

## Important Notes

- The flake target is always `#mbp` for this system
- User is `tolki` with home directory `/Users/tolki`
- Home Manager state version is 24.11
- Scripts in `scripts/` directory are linked to user home for AeroSpace automation
