{ pkgs }:

with pkgs; [
  nodePackages.nodemon
  nodePackages.npm
  nodePackages.pnpm
  nodejs
  bun
  deno
  yarn
]
