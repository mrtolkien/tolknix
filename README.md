# Tolknix

Cross-platform Nix configuration for **macOS** (via nix-darwin) and **Linux** (via standalone home-manager).

I try to add as much of my config as possible to it, the exceptions being:

- Extremely bleeding edge software that wants to self-update (claude, uv, ...)
- Graphical applications that don't play well with Nix installs (happens often on Linux)

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
│
├── darwin/
│   ├── configuration.nix       # System settings (Dock, Finder, etc.)
│   ├── home.nix                # macOS home-manager entry
│   ├── packages.nix            # macOS-only packages
│   └── dotfiles/               # macOS-only dotfiles (aerospace, ...)
│
└── linux/
    ├── home.nix                # Linux home-manager entry
    ├── packages.nix            # Linux-only packages (etc.)
    └── dotfiles/*              # Linux-only dotfiles
```

## Installation

### Arch Linux / CachyOS

```bash
sudo pacman -S nix
sudo systemctl enable --now nix-daemon.service
sudo usermod -aG nix-users $USER

# Log out and back in (or reboot) for group to take effect

# Enable experimental features
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF

git clone <repo-url> ~/.config/tolknix
cd ~/.config/tolknix

nix run home-manager/master -- switch --flake .#tolki@cachyos

# Actually apply your tolknix configuration
home-manager switch --flake ~/.config/tolknix#tolki@cachyos
```

Subsequent updates:

```bash
home-manager switch --flake ~/.config/tolknix#tolki@cachyos
```

### MacOS

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon

git clone <repo-url> ~/.config/tolknix
cd ~/.config/tolknix

nix run nix-darwin -- switch --flake .#mbp
```

Susequent updates:

```bash
darwin-rebuild switch --flake .#mbp
```

## Usage

### Updating Packages (Get Latest Versions)

With flakes, package versions are **pinned** in `flake.lock`. To get newer versions:

```bash
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

## Common Tasks

### Garbage Collection
```bash
# macOS
nix-collect-garbage --delete-older-than 30d
sudo nix-collect-garbage --delete-older-than 30d

# Linux
nix-collect-garbage --delete-older-than 30d
```

## Contributing

This is a personal configuration, but feel free to use it as inspiration or a starting point for your own setup.

## License

MIT - Use freely, no attribution required.
