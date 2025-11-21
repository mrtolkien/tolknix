# Hyprland Configuration for Nix

This is a simplified, modular Hyprland configuration designed for easy migration to Nix/Home Manager.

## Structure

```
nix/
├── hyprland.conf      # Main entry point - sources all other configs
├── general.conf       # Appearance & animations (no dependencies)
├── input.conf         # Keyboard, mouse, gestures (no dependencies)
├── monitors.conf      # Monitor setup (customize for your hardware)
├── workspaces.conf    # Workspace assignments (customize for your monitors)
├── env.conf           # Environment variables (external dependencies)
├── execs.conf         # Startup applications (external dependencies)
├── keybinds.conf      # Keybindings (external dependencies)
├── rules.conf         # Window & layer rules (some dependencies)
└── README.md          # This file
```

## Files by Dependency Type

### No External Dependencies (Core Hyprland)
- `general.conf` - Pure Hyprland settings
- `input.conf` - Pure Hyprland settings

### System-Specific (Customize These)
- `monitors.conf` - Update with your monitor names/resolutions
- `workspaces.conf` - Update monitor names to match your setup

### External Dependencies (Most packages required)
- `env.conf` - Requires: ghostty, nvim, Qt/KDE packages
- `execs.conf` - Requires: Various system utilities (see file header)
- `keybinds.conf` - Requires: Scripts + many utilities (see file header)
- `rules.conf` - Some rules are app-specific (see file header)

## Required Scripts

The keybinds depend on these scripts from your original config:
- `~/.config/hypr/hyprland/scripts/workspace_action.sh` - Intelligent workspace switching
- `~/.config/hypr/hyprland/scripts/launch_first_available.sh` - App launcher fallbacks
- `~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh` - Emoji picker
- `~/.config/hypr/hyprland/scripts/yazi_with_shell.sh` - Yazi file manager launcher

Make sure to include these scripts when migrating to Nix.

## Usage

To test this configuration:
```bash
# Backup your current config
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup

# Symlink or copy the new main config
ln -s ~/.config/hypr/nix/hyprland.conf ~/.config/hypr/hyprland.conf

# Reload Hyprland
hyprctl reload
```

## Migrating to Nix/Home Manager

Each configuration file includes:
- Clear headers explaining what it does
- Inline dependency documentation
- Links to Hyprland wiki where relevant

This makes it easy to translate into Nix Home Manager configuration.

## Key Features Preserved

✅ Multi-monitor workspace setup (1-10 on DP-2, 11-20 on HDMI-A-1)
✅ Intelligent workspace switching via workspace_action.sh
✅ Window groups (tabbed/stacked windows)
✅ Gaming optimizations (tearing support, XWayland scaling)
✅ Material Design 3 animations
✅ Comprehensive window management keybinds
✅ Media controls, screenshots, clipboard history

## What Was Removed

❌ All quickshell dependencies (bar, sidebars, overview, etc.)
❌ Super key tap-to-launch system
❌ Quickshell-specific gestures
❌ Dynamic theming integration (matugen/quickshell)

## Next Steps

1. Customize `monitors.conf` and `workspaces.conf` for your setup
2. Review `execs.conf` and remove applications you don't use
3. Review `keybinds.conf` and adjust to your preferences
4. Test the configuration
5. Begin Nix/Home Manager migration using file headers as reference
