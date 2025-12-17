{ pkgs, ... }:

let
  name = "mrtolkien";
  email = "gary.mialaret@gmail.com";
in {
  # Shared home-manager configuration for both macOS and Linux
  # Platform-specific configs import this and add overrides

  news.display = "show";
  home = {
    stateVersion = "24.11";
    enableNixpkgsReleaseCheck = false; # Disable version check for unstable

    # Note: nixpkgs.config is set at the system/flake level, not here
    # (darwin/configuration.nix for macOS, flake.nix for Linux)

    # Shared packages
    packages = pkgs.callPackage ./packages.nix { };

    # Shared dotfiles
    file = {
      ".config/lsd/config.yaml".source = ./dotfiles/lsd.yaml;
      ".config/ghostty/config".source = ./dotfiles/ghostty.conf;
      ".config/ghostty/cursor_blaze.glsl".source = ./dotfiles/cursor_blaze.glsl;
      ".config/lazygit/config.yml".source = ./dotfiles/lazygit.yml;
    };
  };

  # Program configurations
  programs = {
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
        n = "nvim";
        # Platform-specific abbreviations added in platform configs
      };

      # Shared shell initialization
      shellInit = ''
        # Add Nix profile to PATH first (critical for home-manager packages)
        fish_add_path ~/.nix-profile/bin
        fish_add_path /nix/var/nix/profiles/default/bin

        function fish_greeting
            fastfetch
        end

        # Set environment variables
        set -gx BUN_INSTALL "$HOME/.bun"
        set -gx HISTIGNORE "pwd:ls:cd"
        set -gx npm_config_prefix "$HOME/.local"

        fish_add_path $BUN_INSTALL/bin # bun
        fish_add_path ~/.local/bin # uvx
        source "$HOME/.cargo/env.fish"

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
    fastfetch.enable = true;

    # Terminal multiplexer
    zellij.enable = true;

    # Git tools
    lazygit.enable = true;

    # Shell prompt - using Linux colorful version as standard
    starship = {
      enable = true;
      enableTransience = true; # Replaces previous prompts with custom string
      settings = builtins.fromTOML (builtins.readFile ./dotfiles/starship.toml);
    };

    # Editor
    helix = {
      enable = true;
      settings =
        builtins.fromTOML (builtins.readFile ./dotfiles/helix/config.toml);
      languages =
        builtins.fromTOML (builtins.readFile ./dotfiles/helix/languages.toml);
    };

    # Git configuration
    git = {
      enable = true;
      ignores = [ "*.swp" ];
      lfs = { enable = true; };
      settings = {
        user = {
          inherit name;
          inherit email;
        };
        init.defaultBranch = "main";
        core = {
          editor = "nvim";
          autocrlf = "input";
        };
        pull.rebase = true;
        rebase.autoStash = true;
        credential."https://github.com" = {
          helper = "!${pkgs.gh}/bin/gh auth git-credential";
        };
        credential."https://gist.github.com" = {
          helper = "!${pkgs.gh}/bin/gh auth git-credential";
        };
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
        mgr = { show_hidden = true; };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
      };
    };
  };
}
