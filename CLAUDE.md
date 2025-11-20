# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### macOS (nix-darwin)

```bash
# Apply configuration changes
darwin-rebuild switch --flake ~/.config/tolknix#mbp

# Build configuration without applying (for testing)
darwin-rebuild build --flake ~/.config/tolknix#mbp

# List generations
darwin-rebuild --list-generations

# Rollback
darwin-rebuild switch --flake ~/.config/tolknix#mbp --rollback
```

### Linux (home-manager standalone)

```bash
# Apply configuration changes
home-manager switch --flake ~/.config/tolknix#tolki@cachyos

# Build configuration without applying (for testing)
home-manager build --flake ~/.config/tolknix#tolki@cachyos

# List generations
home-manager generations

# Rollback to specific generation
/nix/store/<generation-path>/activate
```

### Both Platforms

```bash
# Format Nix files
nixpkgs-fmt *.nix **/*.nix

# Update flake inputs
nix flake update

# Check flake
nix flake check
nix flake show

# Garbage collection
nix-collect-garbage --delete-older-than 30d
```

## Architecture Overview

This is a **cross-platform Nix configuration** supporting:

- **macOS**: Full system via nix-darwin + home-manager
- **Linux**: User environment via standalone home-manager

### File Structure

**Entry Point:**
- **flake.nix**: Main entry defining both `darwinConfigurations.mbp` and `homeConfigurations.tolki@cachyos`

**Shared Configurations (common/):**
- **packages.nix**: CLI tools for both platforms (fish, git, helix, etc.)
- **home-manager.nix**: Program configurations (shell, editors, git settings)
- **dotfiles/**: Config files (starship, ghostty, helix, lazygit, lsd)
  - Uses Linux colorful starship.toml as standard
  - Ghostty includes custom cursor shader (cursor_blaze.glsl)

**macOS-Specific (darwin/):**
- **configuration.nix**: System-level Darwin config (fonts, defaults, user setup)
- **home.nix**: macOS home-manager entry (imports common + adds overrides)
- **packages.nix**: macOS-only packages (cocoapods)
- **dotfiles/**: AeroSpace config, macOS-specific Ghostty settings
- **scripts/**: AeroSpace automation scripts

**Linux-Specific (linux/):**
- **home.nix**: Linux home-manager entry (imports common + adds overrides)
- **packages.nix**: Linux-only packages (solaar)
- **dotfiles/**: Custom keyboard layout (us_macos for accents)
- **hyprland/**: Prepared for future migration (not yet active)

### Key Configuration Patterns

1. **Modular Structure**:
   - Common configs define shared behavior
   - Platform configs import common and add/override as needed
   - Uses `lib.mkMerge` and `lib.mkAfter` for extensions

2. **Dotfile Management**:
   - Configuration files stored in respective `dotfiles/` directories
   - Linked via `home.file` in platform-specific home.nix
   - Common dotfiles shared, platform-specific configs separate

3. **Package Management**:
   - Shared packages in `common/packages.nix`
   - Platform packages combined: `(common) ++ (platform)`

4. **TOML Integration**:
   - Configs use `builtins.fromTOML (builtins.readFile path)`
   - Allows external files instead of inline Nix attrs

### Platform Targets

| Target | Platform | System | User | Purpose |
|--------|----------|--------|------|---------|
| `#mbp` | macOS | aarch64-darwin | tolki | Full system via nix-darwin |
| `#tolki@cachyos` | Linux | x86_64-linux | tolki | User environment only |

## User Environment

### Shared Tools

**Shell:**
- Fish with custom abbreviations, vi mode
- Starship prompt (colorful, multi-line, git status with emojis)
- Atuin history (directory-based filtering)
- Zoxide (smart directory jumper)
- Carapace (completions)
- Direnv (directory env vars)

**Editors:**
- Helix (primary, configured via dotfiles)
- Neovim (fallback, set as default editor)

**Terminal Tools:**
- Yazi file manager (wrapper named `y`)
- Lazygit git UI
- LSD for directory listing
- FZF fuzzy finder
- Zellij multiplexer

**Git:**
- User: mrtolkien (gary.mialaret@gmail.com)
- Difftastic for diffs
- LFS enabled
- Auto-rebase on pull

### macOS-Specific

**System Defaults:**
- Keyboard: Fast repeat (KeyRepeat: 1, InitialKeyRepeat: 12), no press-and-hold
- Dock: Auto-hide, left orientation, 48px tiles
- Finder: Show all extensions, list view
- Trackpad: Three-finger drag disabled

**Shell Additions:**
- PATH: Homebrew (`/opt/homebrew/bin`), Flutter, FVM, Bun
- Abbreviations: `f` (open in Finder), `v` (Obsidian vault)

**Applications:**
- AeroSpace window manager (configured via dotfiles)

### Linux-Specific

**Shell Additions:**
- PATH: Standard Linux paths + Bun, uvx
- Activation script: Installs keyboard layout to /usr/share/X11/xkb/symbols/us_macos

**Keyboard Layout:**
- Custom us_macos layout for macOS-style accents
- AltGr-based dead keys (e → é, i → î, u → ü, c → ç)

**Tools:**
- Solaar for Logitech devices

## Modifying Configuration

### Adding Shared Packages

Edit `common/packages.nix`:
```nix
with pkgs; [
  # ... existing packages
  new-package-name
]
```

### Adding Platform-Specific Packages

Edit `darwin/packages.nix` or `linux/packages.nix`

### Modifying Shared Programs

Edit `common/home-manager.nix`:
```nix
{
  program-name = {
    enable = true;
    # ... settings
  };
}
```

### Adding Platform-Specific Overrides

Edit `darwin/home.nix` or `linux/home.nix`:
```nix
programs.fish.shellInit = lib.mkAfter ''
  # Platform-specific shell init
'';
```

### Updating Dotfiles

**Shared:** Edit files in `common/dotfiles/`
**Platform-specific:** Edit files in `darwin/dotfiles/` or `linux/dotfiles/`

Changes take effect on next build/switch.

## Migration Strategy (Linux)

The Linux configuration is designed for **gradual migration**:

### Current State (Phase 1)
- ✅ home-manager manages shell tools, editors, CLI utilities
- ❌ Hyprland remains in `~/.config/hypr/` (not nix-managed)
- ❌ System packages stay with pacman/yay

### Future State (Phase 2)
- Move Hyprland configs to `linux/hyprland/`
- Uncomment home.file sections in `linux/home.nix`
- home-manager links Hyprland configs

See `linux/hyprland/README.md` for migration plan.

## Important Notes

### macOS
- User home directory: `/Users/tolki`
- Lazygit config in `Library/Application Support/`
- Requires Xcode Command Line Tools
- System-level changes require nix-darwin rebuild

### Linux
- User home directory: `/home/tolki`
- Lazygit config in `.config/`
- Keyboard layout installation requires sudo (prompted during switch)
- Only user-level packages managed (system packages via pacman untouched)
- Hyprland NOT managed by nix yet

### Both
- Home Manager state version: 24.11
- Flake uses nixos-unstable channel
- Backup files created with `.bak` extension
- Ghostty includes custom cursor shader (blaze effect)

## Troubleshooting

### Build Fails on Linux
- Ensure Nix is installed: `nix --version`
- Check flake syntax: `nix flake check`
- Update inputs: `nix flake update`

### Build Fails on macOS
- Ensure nix-darwin is initialized
- Check system is aarch64-darwin: `uname -m`
- Verify configuration.nix syntax

### Fish Config Not Loading
- Check PATH: `echo $PATH | grep nix`
- Verify fish from nix: `which fish`
- Restart terminal/shell

### Ghostty Shader Not Working
- Check files exist: `ls ~/.config/ghostty/*.glsl`
- Verify config: `cat ~/.config/ghostty/config | grep shader`
- Reload Ghostty: Super+R

### Keyboard Layout Issues (Linux)
- Check installation: `ls -l /usr/share/X11/xkb/symbols/us_macos`
- Reinstall: Run activation script manually or `home-manager switch` again
- Verify Hyprland config: `hyprctl getoption input:kb_layout`

## Development Workflow

1. Edit configuration files
2. Test build: `darwin-rebuild build` or `home-manager build`
3. Review changes: Check what would change
4. Apply: `darwin-rebuild switch` or `home-manager switch`
5. If issues: Rollback to previous generation

## When to Use Which File

| Task | macOS | Linux | Shared |
|------|-------|-------|--------|
| Add CLI tool | darwin/packages.nix | linux/packages.nix | common/packages.nix |
| Configure program | darwin/home.nix | linux/home.nix | common/home-manager.nix |
| System setting | darwin/configuration.nix | N/A | N/A |
| Dotfile | darwin/dotfiles/ | linux/dotfiles/ | common/dotfiles/ |
| Window manager | darwin/ (AeroSpace) | ~/.config/hypr/ (not nix yet) | N/A |
