{ pkgs }:

let
  cli = import ./packages/cli.nix { inherit pkgs; };
  dev = import ./packages/dev.nix { inherit pkgs; };
  nodejs = import ./packages/nodejs.nix { inherit pkgs; };
  rust = import ./packages/rust.nix { inherit pkgs; };
in
cli ++ dev ++ nodejs ++ rust
