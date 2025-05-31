{ pkgs, ... }:

let
  name = "mrtolkien";
  email = "gary.mialaret@gmail.com";
in
{
  home-manager.enable = true;

  fish = {
    enable = true;
    shellAbbrs = {
      dps = "docker ps";
      f = "open .";
      v = "y '/Users/tolki/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vaulki'";
      l = "lazygit";
    };

    shellInit = ''
      # Set environment variables
      set -gx BUN_INSTALL "$HOME/.bun"
      set -gx HISTIGNORE "pwd:ls:cd"

      # Add paths using fish_add_path (preferred method)
      fish_add_path $BUN_INSTALL/bin # bun
      fish_add_path ~/.local/bin # uvx
      fish_add_path /opt/homebrew/bin # brew
      fish_add_path ~/Development/flutter/bin # flutter
    '';

  };

  fzf.enable = true;
  lsd.enable = true;
  direnv.enable = true;
  zellij.enable = true;
  zoxide.enable = true;
  starship.enable = true;
  carapace.enable = true;
  tealdeer.enable = true;

  aerospace = {
    enable = true;
    userSettings = builtins.fromTOML (builtins.readFile ./dotfiles/aerospace.toml);
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  atuin = {
    enable = true;
    settings = {
      filter_mode_shell_up_key_binding = "directory";
      dialect = "uk";
    };
  };

  neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  yazi = {
    enable = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };
  };

}
