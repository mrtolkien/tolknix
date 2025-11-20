{ config, pkgs, lib, ... }:

let
  name = "mrtolkien";
  email = "gary.mialaret@gmail.com";
in
{
  # Shared program configurations for both macOS and Linux

  fish = {
    enable = true;

    # Enable vi keybindings
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';

    # Shared abbreviations
    shellAbbrs = {
      dps = "docker ps";
      l = "lazygit";
      n = "nvim .";
      # Platform-specific abbreviations added in platform configs
    };

    # Shared shell initialization
    shellInit = ''
      # Set environment variables
      set -gx BUN_INSTALL "$HOME/.bun"
      set -gx HISTIGNORE "pwd:ls:cd"

      fish_add_path $BUN_INSTALL/bin # bun
      fish_add_path ~/.local/bin # uvx

      # Quickshell terminal color sequences (if available)
      if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
          cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
      end

      # Platform-specific PATHs added in platform configs
    '';
  };

  # Shell enhancements
  fzf.enable = true;
  lsd.enable = true;
  direnv.enable = true;
  zoxide.enable = true;
  carapace.enable = true;
  tealdeer.enable = true;

  # Terminal multiplexer
  zellij.enable = true;

  # Git tools
  lazygit.enable = true;

  # Shell prompt - using Linux colorful version as standard
  starship = {
    enable = true;
    enableTransience = false;  # Disabled: uses deprecated fish bind syntax
    settings = builtins.fromTOML (builtins.readFile ./dotfiles/starship.toml);
  };

  # Editor
  helix = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./dotfiles/helix/config.toml);
    languages = builtins.fromTOML (builtins.readFile ./dotfiles/helix/languages.toml);
  };

  # Git configuration
  git = {
    enable = true;
    ignores = [ "*.swp" ];
    lfs = {
      enable = true;
    };
    settings = {
      user = {
        name = name;
        email = email;
      };
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  # Difftastic (git diff tool)
  difftastic = {
    enable = true;
    git.enable = true;
  };

  # Shell history
  atuin = {
    enable = true;
    settings = {
      filter_mode_shell_up_key_binding = "directory";
      dialect = "uk";
    };
  };

  # Neovim editor
  neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # File manager
  yazi = {
    enable = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };
  };
}
