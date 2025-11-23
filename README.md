# Tolknix

Cross-platform Nix configuration for **macOS** (via nix-darwin) and **Linux** (via standalone home-manager).

## Overview

This repository provides a unified, reproducible development environment across platforms with:

- **Shared CLI tools**: fish, starship, atuin, zoxide, git, helix, neovim, yazi, and more
- **Platform-specific configs**: System settings (macOS), window managers, device managers
- **Declarative package management**: Same tools, exact versions, anywhere
- **Modular structure**: Common configs + platform-specific overrides

## Repository Structure

```
tolknix/
├── flake.nix                    # Nix flake entry point (both platforms)
├── flake.lock                   # Dependency lockfile
├── nix.conf                     # Nix settings
│
├── common/                      # Shared configurations
│   ├── packages.nix            # CLI tools for both platforms
│   ├── home-manager.nix        # Shared program configs
│   └── dotfiles/               # Shared config files
│       ├── starship.toml       # Shell prompt
│       ├── ghostty.conf        # Terminal base config
│       ├── cursor_blaze.glsl   # Ghostty cursor shader
│       ├── cursor_trail.glsl   # Ghostty cursor shader (alt)
│       ├── helix/              # Editor configs
│       ├── lazygit.yml         # Git UI config
│       └── lsd.yaml            # Directory listing config
│
├── darwin/                      # macOS-specific
│   ├── configuration.nix       # System settings (Dock, Finder, etc.)
│   ├── home.nix                # macOS home-manager entry
│   ├── packages.nix            # macOS-only packages
│   ├── dotfiles/
│   │   ├── ghostty-darwin.conf # macOS titlebar settingm
│   │   └── aerospace.toml      # Window manager config
│   └── scripts/                # AeroSpace automation scripts
│
└── linux/                       # Linux-specific
    ├── home.nix                # Linux home-manager entry
    ├── packages.nix            # Linux-only packages (etc.)
    ├── dotfiles/
    │   └── xkb-custom-macos    # Custom keyboard layout (accents)
    └── hyprland/               # Prepared for future migration
        └── README.md           # Not yet managed by nix
```

## What's Managed

### Shared Across Platforms

**Shell Environment:**
- fish (shell) + starship (prompt) + atuin (history)
- zoxide (smart cd) + carapace (completions) + direnv (env vars)

**CLI Tools:**
- File management: yazi, lsd, fd, ripgrep, bat
- Editors: helix, neovim
- Git: git, gh, lazygit, difftastic
- Development: rustup, go, nodejs, deno, zig, cmake
- Data: postgresql, jq, yq, rclone
- Nix: nil, nixpkgs-fmt

**Terminal:**
- Ghostty with custom cursor shader

**Multiplexer:**
- Zellij

### macOS-Specific

**System Configuration:**
- Dock, Finder, Keyboard, Trackpad settings
- Nerd Fonts (system-wide)

**Applications:**
- AeroSpace (window manager)
- Homebrew integration

**Development:**
- Flutter toolchain (cocoapods, FVM)

### Linux-Specific

**Customizations:**
- Custom keyboard layout for macOS-style accent shortcuts
- Prepared Hyprland integration (not yet active)

## Installation

### Prerequisites

#### Install Nix

**Arch Linux / CachyOS (Recommended):**
```bash
# Install from AUR (integrates with pacman)
yay -S nix

# Enable nix-daemon
sudo systemctl enable --now nix-daemon.service

# Add yourself to nix-users group
sudo usermod -aG nix-users $USER

# Log out and back in (or reboot) for group to take effect

# Enable experimental features
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF

# Verify
nix --version
```

**Other Linux / macOS:**
```bash
# Install Nix package manager (official script)
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**macOS only:**
```bash
# Install Xcode Command Line Tools
xcode-select --install
```

### macOS Setup

```bash
# Clone this repo
git clone <repo-url> ~/.config/tolknix
cd ~/.config/tolknix

# First-time installation
nix run nix-darwin -- switch --flake .#mbp

# Subsequent updates
darwin-rebuild switch --flake .#mbp
```

### Linux Setup (CachyOS / Arch / Any Distro)

```bash
# Clone this repo (if not already there)
git clone <repo-url> ~/.config/tolknix
cd ~/.config/tolknix

# Initialize home-manager (one-time, creates ~/.config/home-manager/ scaffolding)
nix run home-manager/master -- switch --flake .#tolki@cachyos

# Actually apply your tolknix configuration
home-manager switch --flake ~/.config/tolknix#tolki@cachyos

# Subsequent updates (just this command)
home-manager switch --flake ~/.config/tolknix#tolki@cachyos
```

# TODO: Mark that solaar and ghostty work better through AUR

**Note:**
- The `init` command creates default files in `~/.config/home-manager/` (you won't use these)
- The `switch` command uses your actual tolknix configuration
- On Linux, home-manager manages **only user-level packages**. Your system packages (via pacman/yay) and Hyprland configs remain untouched.

## Usage

### Updating Packages (Get Latest Versions)

With flakes, package versions are **pinned** in `flake.lock`. To get newer versions:

```bash
cd ~/.config/tolknix

# Update all inputs (nixpkgs, home-manager, etc.)
nix flake update

# Or update just nixpkgs
nix flake update nixpkgs

# Then rebuild to apply
# macOS:
darwin-rebuild switch --flake .#mbp

# Linux:
home-manager switch --flake .#tolki@cachyos
```

**What happens:**
- `nix flake update` updates `flake.lock` with latest versions from GitHub
- The rebuild downloads and installs the new packages
- Your configuration stays the same, just newer package versions

**How often:** Weekly or monthly is typical. Check what will update first:
```bash
nix flake lock --update-input nixpkgs --dry-run
```

### Updating Configuration (Change Settings)

1. **Edit files:**
   - Shared settings: Edit `common/home-manager.nix` or `common/packages.nix`
   - Platform-specific: Edit `darwin/home.nix` or `linux/home.nix`
   - Dotfiles: Edit files in respective `dotfiles/` directories

2. **Apply changes:**
   ```bash
   # macOS
   darwin-rebuild switch --flake ~/.config/tolknix#mbp

   # Linux
   home-manager switch --flake ~/.config/tolknix#tolki@cachyos
   ```

**Note:** You can update configuration WITHOUT updating packages - just skip the `nix flake update` step.

### Adding Packages

**For both platforms:**
Add to `common/packages.nix`

**Platform-specific:**
Add to `darwin/packages.nix` or `linux/packages.nix`

### Rollback

**macOS:**
```bash
darwin-rebuild --list-generations
darwin-rebuild switch --flake .#mbp --rollback
```

**Linux:**
```bash
home-manager generations
/nix/store/<generation-path>/activate
```

## Platform Differences

### File Paths

| Config | macOS | Linux |
|--------|-------|-------|
| Lazygit | `~/Library/Application Support/lazygit/` | `~/.config/lazygit/` |
| Ghostty extras | Includes macOS titlebar settings | Standard settings only |

### Shell Initialization

**macOS adds:**
- Homebrew (`/opt/homebrew/bin`)
- Flutter/FVM paths
- Fish abbreviation: `f` (open in Finder), `v` (Obsidian vault)

**Linux adds:**
- Standard Linux paths only
- Keyboard layout installation (requires sudo)

### Window Management

- **macOS**: AeroSpace (nix-managed)
- **Linux**: Hyprland (not yet nix-managed, stays in `~/.config/hypr/`)

## Migration Strategy (Linux)

This configuration is designed for **gradual migration** on Linux:

### Phase 1: Shell Tools (Current)
✅ home-manager manages: fish, atuin, zoxide, git, editors, CLI tools
❌ System untouched: Hyprland, quickshell, system packages

### Phase 2: Hyprland (Future)
When ready:
1. Move Hyprland configs to `linux/hyprland/`
2. Uncomment relevant sections in `linux/home.nix`
3. Run `home-manager switch`

See `linux/hyprland/README.md` for details.

## Common Tasks

### Format Nix Files
```bash
nixpkgs-fmt *.nix **/*.nix
```

### Garbage Collection
```bash
# macOS
nix-collect-garbage --delete-older-than 30d
sudo nix-collect-garbage --delete-older-than 30d

# Linux
nix-collect-garbage --delete-older-than 30d
```

### View What's Installed
```bash
# macOS
darwin-rebuild build --flake .#mbp && ls -l result

# Linux
home-manager build --flake .#tolki@cachyos && ls -l result
```

### Check Flake
```bash
nix flake check
nix flake show
```

## Customization

### User Information

Edit `common/home-manager.nix`:
```nix
let
  name = "mrtolkien";
  email = "gary.mialaret@gmail.com";
in
```

### Starship Prompt

Edit `common/dotfiles/starship.toml` - currently using colorful multi-line format with:
- Git status with emojis
- Command duration
- Directory aliases
- Sudo indicator
- Custom OS symbols

### Ghostty Theme

Edit `common/dotfiles/ghostty.conf`:
```
theme = flexoki-dark  # Change theme
custom-shader = ~/.config/ghostty/cursor_blaze.glsl  # Change or disable shader
```

### Keyboard Layout (Linux)

The custom layout (`linux/dotfiles/xkb-custom-macos`) provides macOS-style accent shortcuts:
- **AltGr+e** then vowel = é, á, etc.
- **AltGr+`** then vowel = è, à, etc.
- **AltGr+i** then vowel = ê, î, etc.
- **AltGr+u** then vowel = ë, ï, etc.
- **AltGr+c** = ç

Automatically installed to `/usr/share/X11/xkb/symbols/us_macos` during `home-manager switch`.

## Troubleshooting

### Build Errors

```bash
# Update flake inputs
nix flake update

# Rebuild
# macOS: darwin-rebuild switch --flake .#mbp
# Linux: home-manager switch --flake .#tolki@cachyos
```

### Fish Config Not Loading

```bash
# Ensure home-manager's fish is in PATH
which fish  # Should show /nix/store/... path

# Restart shell or terminal
```

### Keyboard Layout Not Working (Linux)

```bash
# Check if installed
ls -l /usr/share/X11/xkb/symbols/us_macos

# Reinstall manually if needed
sudo cp ~/.config/xkb-custom-macos /usr/share/X11/xkb/symbols/us_macos

# Verify in Hyprland
hyprctl getoption input:kb_layout
```

### Ghostty Shader Not Showing

```bash
# Check files exist
ls -la ~/.config/ghostty/*.glsl

# Reload Ghostty config
# In Ghostty: Super+R
```

## Contributing

This is a personal configuration, but feel free to use it as inspiration or a starting point for your own setup.

## License

MIT - Use freely, no attribution required.
