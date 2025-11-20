{
  description = "Tolki's cross-platform Nix configuration (macOS + Linux)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
    # macOS configuration via nix-darwin + home-manager
    darwinConfigurations = {
      mbp = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tolki = import ./darwin/home.nix;
            home-manager.backupFileExtension = ".bak";
          }
        ];
      };
    };

    # Linux configuration via standalone home-manager
    homeConfigurations = {
      "tolki@cachyos" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [
          ./linux/home.nix
          {
            home.username = "tolki";
            home.homeDirectory = "/home/tolki";
          }
        ];
      };
    };
  };
}
