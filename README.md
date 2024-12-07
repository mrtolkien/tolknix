# Tolknix

My `nix` based Mac OS configuration.

## Commands

First run:

```sh
nix run nix-darwin -- switch --flake ~/.config/nix#mbp
```

Subsequent runs:

```sh
darwin-rebuild switch --flake ~/.config/nix#mbp
```

Build only:

```sh
darwin-rebuild build --flake ~/.config/nix#mbp
```
