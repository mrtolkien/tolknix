{ config, pkgs, lib, ... }:

{
  ###############################################
  # OPTIONS ARE HERE
  # https://nix-community.github.io/home-manager/options.xhtml
  ###############################################

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Programs are packages that are also *configured* by Home Manager. 
  programs = { } // import ./home-manager.nix { inherit config pkgs lib; };

  home.shell.enableFishIntegration = true;

  # Packages are just installed by Home Manager.
  home.packages = pkgs.callPackage ./packages.nix { };

  # Dotfiles to configure some packages
  home.file = {
    ".aerospace.toml".source = dotfiles/aerospace.toml;
    ".config/alacritty/alacritty.toml".source = dotfiles/alacritty.toml;
    ".config/helix/config.toml".source = dotfiles/helix/config.toml;
    ".config/helix/languages.toml".source = dotfiles/helix/languages.toml;
    ".config/lsd/config.yaml".source = dotfiles/lsd.yaml;
    ".config/starship.toml".source = dotfiles/starship.toml;
    ".config/ghostty/config".source = dotfiles/ghostty.conf;
    "Library/Application Support/lazygit/config.yml".source = dotfiles/lazygit.yml;
    "scripts/aerospace_horizontal.sh".source = scripts/aerospace_horizontal.sh;
    "scripts/aerospace_reset.sh".source = scripts/aerospace_reset.sh;
  };
}
