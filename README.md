# Tolknix

Cross-platform Nix configuration for **macOS** (via nix-darwin) and **Linux** (via standalone home-manager).

I try to add as much of my config as possible to it, the exceptions being:

- Extremely bleeding edge software that wants to self-update (claude, uv, ...)
- Graphical applications that don't play well with Nix installs (happens often on Linux)

## Repository Structure

```
tolknix/
├── flake.nix                    # Entry point: both targets, formatter, checks
├── flake.lock                   # Dependency lockfile
│
├── common/                      # Shared between both platforms
│   ├── home.nix                # Shared program configs
│   ├── packages.nix            # CLI tools for both platforms
│   └── dotfiles/               # Shared config files
│
├── darwin/
│   ├── configuration.nix       # System settings (Dock, Finder, etc.)
│   ├── home.nix                # macOS home-manager entry
│   ├── packages.nix            # macOS-only packages
│   ├── dotfiles/               # macOS-only dotfiles (aerospace, ...)
│   └── scripts/                # AeroSpace scripts
│
└── linux/
    ├── home.nix                # Linux home-manager entry
    ├── desktop.nix             # Hyprland, Noctalia, IME, file associations
    ├── packages.nix            # Linux-only packages
    └── dotfiles/               # Linux-only dotfiles (hypr, noctalia, xkb)
```

Each `dotfiles/` directory mirrors the layout of `~/.config`.

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

git clone <repo-url> tolknix
cd tolknix

# First run: home-manager is not installed yet
nix run home-manager/master -- switch --flake .#tolki@cachyos
```

Subsequent updates, from the repository root:

```bash
home-manager switch --flake .#tolki@cachyos
```

### macOS

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon

git clone <repo-url> tolknix
cd tolknix

sudo -H nix run nix-darwin -- switch --flake .#mbp
```

Subsequent updates:

```bash
sudo -H darwin-rebuild switch --flake .#mbp
```

#### Changing the macOS username

If the macOS account username changes, update both the nix-darwin system user
and the Home Manager user before rebuilding.

In `flake.nix`, update the Home Manager user attribute:

```nix
home-manager.users.<new-username> = import ./darwin/home.nix;
```

In `darwin/configuration.nix`, update:

```nix
users.knownUsers = [ "<new-username>" ];

users.users.<new-username> = {
  name = "<new-username>";
  uid = 501;
  gid = 20;
  home = "/Users/<new-username>";
  shell = pkgs.fish;
};

system.primaryUser = "<new-username>";
```

`users.knownUsers` is required for nix-darwin to manage an existing macOS
account and update Directory Services fields like the login shell.

In `darwin/home.nix`, update:

```nix
home.username = "<new-username>";
home.homeDirectory = "/Users/<new-username>";
```

Then apply with:

```bash
sudo -H nix run nix-darwin -- switch --flake .#mbp
```

Open a new terminal and verify:

```bash
echo $SHELL
echo $EDITOR
type zoxide
```

## Usage

All commands run from the repository root.

### Formatting and Checks

```bash
# Format every Nix file
nix fmt

# Check formatting, lint (statix, deadnix) and build this machine's
# configuration without applying it
nix flake check
```

### Updating Packages (Get Latest Versions)

With flakes, package versions are **pinned** in `flake.lock`. To get newer versions:

```bash
# Update all inputs (nixpkgs, home-manager, etc.)
nix flake update

# Or update just nixpkgs
nix flake update nixpkgs

# Then rebuild to apply
# macOS:
sudo -H darwin-rebuild switch --flake .#mbp

# Linux:
home-manager switch --flake .#tolki@cachyos
```

### Adding Packages

**For both platforms:**
Add to `common/packages.nix`. The package must exist on both platforms.

**Platform-specific:**
Add to `darwin/packages.nix` or `linux/packages.nix`

### Rollback

**macOS:**
```bash
sudo -H darwin-rebuild --list-generations
sudo -H darwin-rebuild switch --flake .#mbp --rollback
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
