{
  description = "Tolki's cross-platform Nix configuration (macOS + Linux)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      ...
    }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
          system: f nixpkgs.legacyPackages.${system}
        );
    in
    {
      # `nix fmt` formats every Nix file with the official formatter
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      # `nix flake check` verifies formatting, lints, and builds this machine's
      # configuration without applying it
      checks = forAllSystems (
        pkgs:
        {
          format = pkgs.runCommand "check-format" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            find ${self} -name '*.nix' -exec nixfmt --check {} +
            touch $out
          '';

          lint =
            pkgs.runCommand "check-lint"
              {
                nativeBuildInputs = [
                  pkgs.statix
                  pkgs.deadnix
                ];
              }
              ''
                statix check ${self}
                deadnix --fail ${self}
                touch $out
              '';
        }
        // nixpkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          home = self.homeConfigurations."tolki@cachyos".activationPackage;
        }
        // nixpkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          system = self.darwinConfigurations.mbp.system;
        }
      );

      # macOS configuration via nix-darwin + home-manager
      darwinConfigurations = {
        mbp = darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.garymialaret = import ./darwin/home.nix;
                backupFileExtension = ".bak";
              };
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
          modules = [ ./linux/home.nix ];
        };
      };
    };
}
