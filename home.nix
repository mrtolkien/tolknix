{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Install user packages through home-manager instead of system configuration
  # This ensures they're available in your user environment
  home.packages = pkgs.callPackage ./packages.nix { };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".aerospace.toml".source = dotfiles/aerospace.toml;
    ".config/alacritty/alacritty.toml".source = dotfiles/alacritty.toml;
    ".config/helix/config.toml".source = dotfiles/helix.toml;
    ".config/lsd/config.yaml".source = dotfiles/lsd.yaml;
    ".config/starship.toml".source = dotfiles/starship.toml;
  };

  imports = [
    ./programs.nix
  ];

  # You can also manage environment variables but you will have to manually
  # source
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

}
