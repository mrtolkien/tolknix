# Hyprland Configuration (Not Yet Managed by Nix)

This directory is prepared for future Hyprland configuration management via nix.

**Current Status:** Hyprland configs remain in `~/.config/hypr/` and are **not managed by nix**.

## Migration Plan

When ready to migrate Hyprland to nix management:

1. **Move configs here:**
   ```
   linux/hyprland/
   ├── custom/
   │   ├── env.conf
   │   ├── execs.conf
   │   ├── general.conf
   │   ├── keybinds.conf
   │   └── rules.conf
   └── scripts/
       └── yazi_with_shell.sh
   ```

2. **Enable in linux/home.nix:**
   Uncomment the `home.file` sections that link Hyprland configs

3. **Update main hyprland.conf:**
   Source the nix-managed configs or fully migrate to nix

## Why Not Yet?

- Allowing gradual migration of tools
- Testing home-manager on Linux first
- Keeping Hyprland workflow unchanged during transition
- Shell tools (fish, atuin, zoxide, etc.) migrated first

## When to Migrate

Migrate when:
- Comfortable with home-manager workflow
- Want version-controlled Hyprland configs
- Ready to have nix manage window manager setup
