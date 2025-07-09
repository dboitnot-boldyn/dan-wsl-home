{ config, pkgs, lib, nixvim, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dboitnot";
  home.homeDirectory = "/home/dboitnot";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ripgrep
    fd
    fira-code
    powerline-symbols
    stow
    dnsutils
    jq
    hunspellDicts.en_US-large
    just
    niv
    bottom
    pik
    tmux
    tmux-mem-cpu-load
    bsdgames
    delta
    pre-commit
    timewarrior
    unzip
    nix-search-cli
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dboitnot/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # atuin provides a fuzzy finder for command line history.
  programs.atuin = {
    enable = true;
    settings = {
      search_mode = "skim";
      show_preview = true;
    };
    flags = ["--disable-up-arrow"];
    enableBashIntegration = true;
    # enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.bash = {
    enable = true;
    historyControl = ["erasedups"];
    shellAliases = {
      atc = "cd ~/tmp && atc";
      top = "btm";
      diff = "delta";
      tmx = "tmux new -At main";
      tw = "timew";
      tws = "timew sum :ids";
      vi = "nvim";
      # emacs = "emacsclient -t";
      emacs = "emacs -nw";
    };
    initExtra = '' 
      eval $(thefuck --alias drat)
    '';
    profileExtra = ''
      fastfetch
      echo
      which -s keychain && eval $(keychain --nogui --eval)
      echo
    '';
  };

  # Carapace auto-completion
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    # enableFishIntegration = true;
  };

  # programs.chromium.enable = true;
  programs.command-not-found.enable = true;

  # "Better cat"
  programs.bat.enable = true;

  # direnv is a tool to load/unload environment variables based on the current
  # directory.
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
  };

  # eza is a modern replacement for ls.
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    # enableAliases = true;
    git = true;
    icons = "auto";
  };

  # programs.fish = {
  #   enabled = true;
  # };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  # programs.firefox = {
  #  enable = true;
  # };

  programs.git = {
    enable = true;
    difftastic.enable = true;
    userEmail = "dboitnot@gmail.com";
    userName = "Dan Boitnott";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      display.color = "blue";
      logo = {
        source = "${config.xdg.configHome}/home-manager/fastfetch_logo";
        color = {
          "1" = "blue";
        };
        padding = {
          top = 2;
          left = 2;
          right = 2;
        };
      };
      modules = [
        "cpu"
        "host"
        "kernel"
        "os"
        "terminal"
        "break"
        "uptime"
        "battery"
        "break"
        "icons"
        "break"
        "colors"
      ];
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
  };
  programs.gh-dash.enable = true;

  # programs.hyfetch = {
  #   enable = true;
  #   settings = {
  #     preset = "progress";
  #     mode = "rgb";
  #     color_align = {
  #       mode = "horizontal";
  #     };
  #   };
  # };

  programs.java.enable = true;

  #
  # neovim configuration
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html
  #
  programs.nixvim = {
    enable = true;

    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "nvim-just";
      src = pkgs.fetchFromGitHub {
        owner = "NoahTheDuke";
        repo = "vim-just";
        rev = "fbe69d1";
        hash = "sha256-PHrJploinNVBkmr97K1qpG5upSoZhZcb0aHlNzZJOUg=";
      };
    })];

    globals = {
      # Disable useless providers
      loaded_ruby_provider = 0; # Ruby
      loaded_perl_provider = 0; # Perl
      loaded_python_provider = 0; # Python 2

      mapleader = ";";
    };

    opts = {
      # Disable mouse integration
      mouse = "";

      # Line numbers
      number = true;
      relativenumber = true;
      scrolloff = 12;
    };

    plugins = {
      chadtree.enable = true;
      comment.enable = true;
      leap.enable = true;
      lsp-format.enable = true;
      lsp-lines.enable = true;
      lsp-signature.enable = true;
      luasnip.enable = true;
      neogit.enable = true;
      neo-tree.enable = true;
      nix.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      web-devicons.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
          { name = "treesitter"; }
        ];
      };

      dashboard = {
        enable = true;
        settings.config = {
          header = lib.strings.splitString "\n" ''
             _           _     _               _    _ _______ 
            | |         | |   | |             | |  | (_______)
            | | _   ___ | | _ | |_   _ ____   | |__| |_____   
            | || \ / _ \| |/ || | | | |  _ \  |  __) |  ___)  
            | |_) ) |_| | ( (_| | |_| | | | | | |  | | |_____ 
            |____/ \___/|_|\____|\__  |_| |_| |_|  |_|_______)
                                (____/                       
          '';
          #   | |__   ___ | | __| |_   _ _ __   /\  /\/__\
          #   | '_ \ / _ \| |/ _` | | | | '_ \ / /_/ /_\  
          #   | |_) | (_) | | (_| | |_| | | | / __  //__  
          #   |_.__/ \___/|_|\__,_|\__, |_| |_\/ /_/\__/  
          #                       |___/                  
          # 
          #       __          __    __            __  ________
          #      / /_  ____  / /___/ /_  ______  / / / / ____/
          #     / __ \/ __ \/ / __  / / / / __ \/ /_/ / __/   
          #    / /_/ / /_/ / / /_/ / /_/ / / / / __  / /___   
          #   /_.___/\____/_/\__,_/\__, /_/ /_/_/ /_/_____/   
          #                       /____/                      
          # 
          #   ______       ______________              ______  ___________
          #   ___  /__________  /_____  /____  ___________  / / /__  ____/
          #   __  __ \  __ \_  /_  __  /__  / / /_  __ \_  /_/ /__  __/   
          #   _  /_/ / /_/ /  / / /_/ / _  /_/ /_  / / /  __  / _  /___   
          #   /_.___/\____//_/  \__,_/  _\__, / /_/ /_//_/ /_/  /_____/   
          #                             /____/                            
        };
      };


      lint = {
        enable = true;
        lintersByFt = {
          clojure = ["clj-kondo"];
          dockerfile = ["hadolint"];
          json = ["jsonlint"];
          markdown = ["vale"];
          terraform = ["tflint"];
        };
      };

      lsp = {
        enable = true;
        servers = {
          # bashls.enable = true;
          # clojure_lsp.enable = true;
          # docker_compose_language_service.enable = true;
          # dockerls.enable = true;
          # elmls.enable = true;
          # groovyls.enable = true;
          # helm_ls.enable = true;
          # jinja_lsp.enable = true;
          # nushell.enable = true;
          pylsp = {
            enable = true;
            settings.plugins.black.enabled = true;
          };
          # terraformls.enable = true;
          yamlls.enable = true;
        };
      };

      navbuddy = {
        enable = true;
        lsp = {
          autoAttach = true;
        };
      };


      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>gf" = "git_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };
    };
  };

  programs.readline = {
    enable = true;
    variables = { 
      editing-mode = "vi"; 
      show-mode-in-prompt = "on";

      # Set the cursor shape to "bar" in insert mode
      # and "block" in command mode.
      vi-cmd-mode-string = "\\1\\e[2 q\\2";
      vi-ins-mode-string = "\\1\\e[6 q\\2";
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    forwardAgent = true;
    extraConfig = ''
      HostKeyAlgorithms +ssh-rsa
      PubkeyAcceptedKeyTypes +ssh-rsa'';
    matchBlocks = 
    let
      bheViaBastion = hostname: {
        inherit hostname;
        user = "dboitnott";
        proxyJump = "bastion.bhe";
      };
      fhdaViaBastion = hostname: {
        inherit hostname;
        user = "dboitnott";
        proxyJump = "bastion.fhda";
      };
    in
    {
      "bastion.bhe" = {
        hostname = "129.153.92.64";
	user = "dboitnott";
      };
      "db.bhe" = bheViaBastion "10.222.33.187";
      "esm.bhe" = bheViaBastion "10.222.33.59";
      "jobsub.bhe" = bheViaBastion "10.222.33.81";

      "bastion.fhda" = {
        # hostname = "129.146.116.252";
        # hostname = "129.153.92.64";
        hostname = "nixbastion.oci.fhda.edu";
        user = "dboitnott";
      };
      "db.nprd.fhda" = fhdaViaBastion "10.222.33.160";
      "olddb.nprd.fhda" = fhdaViaBastion "10.222.33.101";
      "db.prod.fhda" = fhdaViaBastion "10.222.49.160";
      "jobsub.nprd.fhda" = fhdaViaBastion "10.222.33.200";
      "jobsub.prod.fhda" = fhdaViaBastion "10.222.49.77";
      "esm.fhda" = fhdaViaBastion "10.222.33.249";
      "odsdb.nprd.fhda" = fhdaViaBastion "10.222.33.227";
      "odsdb.prod.fhda" = fhdaViaBastion "10.222.49.181";
      "ods.prod.fhda" = fhdaViaBastion "10.222.49.190";

      "jobsub.prod.sbcc" = {
        hostname = "jobsub.opc.sbcc.net";
        user = "boldyn";
      };
      "db.prod.sbcc" = {
        hostname = "db.prod.opc.sbcc.net";
        user = "boldyn";
      };

    #   "*.school" = {
    #     proxyCommand = "~/.ssh/ssm-ssh-proxy.sh -r cbu -f 1 -h %h -p %p -v -R us-west-2";
    #   };
    };
  };

  # home.file.ssh-ssh-proxy = {
  #   executable = true;
  #   source = ./ssm-ssh-proxy.sh;
  #   target = ".ssh/ssm-ssh-proxy.sh.link";

  #   # SSH doesn't like this file to be a symlink so we'll "realize" it.
  #   onChange = "cp -f .ssh/ssm-ssh-proxy.sh.link .ssh/ssm-ssh-proxy.sh";
  # };

  # tealdeer is a command line client for tldr-pages. To use it, run:
  #   $ tldr <command>
  programs.tealdeer = {
    enable = true;
    settings = {
      display.compact = false;
      updates.auto_update = true;
    };
  };

  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-blue-256";
    package = pkgs.taskwarrior3;
  };

  programs.thefuck = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true;
    # enableNushellIntegration = true;
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    sensibleOnTop = false;
    terminal = "xterm-256color";
    tmuxp.enable = true;

    extraConfig = ''
      set -g status-interval 2

      # Move around panes with hjkl, as one would in vim after pressing ctrl + w
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Use shift + arrow key to move between windows in a session
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Use r to quickly reload tmux settings
      unbind r
      bind r \
              source-file ~/.config/tmux/tmux.conf \;\
              display 'Reloaded tmux config'

      # Length of tmux status line
      set -g status-left-length 30
      set -g status-right-length 150

      set-option -g status "on"

      # Use '-' & '|' to split windows instead of '"' & '%' because they're awkward
      bind '-' split-window -c "#{pane_current_path}"
      bind '|' split-window -hc "#{pane_current_path}"

      # Rebind 'c' to open a new window _in the current path_
      bind c new-window -c "#{pane_current_path}"

      # Default statusbar color
      set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

      # Default window title colors
      set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

      # Default window with an activity alert
      set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

      # Active window title colors
      set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

      # Set active pane border color
      set-option -g pane-active-border-style fg=colour214

      # Set inactive pane border color
      set-option -g pane-border-style fg=colour239

      # Message info
      set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

      # Writing commands inactive
      set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

      # Pane number display
      set-option -g display-panes-active-colour colour1 #fg2
      set-option -g display-panes-colour colour237 #bg1

      # Clock
      set-window-option -g clock-mode-colour colour109 #blue

      # Bell
      set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

      set-option -g status-left "\
      #[fg=colour7, bg=colour241]#{?client_prefix,#[bg=colour167],} ❐ #S \
      #[fg=colour241, bg=colour237]#{?client_prefix,#[fg=colour167],}#{?window_zoomed_flag, 🔍,}"

      set-option -g status-right "\
      #[fg=colour246, bg=colour237]  #(tmux-mem-cpu-load --interval 2 -a0)\
      #[fg=colour246, bg=colour237]  %a, %b %d '%y\
      #[fg=colour109]  %l:%M %p \
      #[fg=colour248, bg=colour239]"

      set-window-option -g window-status-current-format "\
      #[fg=colour237, bg=colour214]\
      #[fg=colour239, bg=colour214] #I* \
      #[fg=colour239, bg=colour214, bold] #W \
      #[fg=colour214, bg=colour237]"

      set-window-option -g window-status-format "\
      #[fg=colour237,bg=colour239,noitalics]\
      #[fg=colour223,bg=colour239] #I \
      #[fg=colour223, bg=colour239] #W \
      #[fg=colour239, bg=colour237]"

      # Set the history limit so we get lots of scrollback.
      setw -g history-limit 50000000
    '';

    # plugins = with pkgs; [
      # {
      #   plugin = tmuxPlugins.resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-save-interval '60' # minutes
      #   '';
      # }
    # ];
  };

  # Nerd font symbol browser:
  # https://www.nerdfonts.com/cheat-sheet
  #
  #       
  #
  # ANSI Color Chart:
  # https://i.sstatic.net/KTSQa.png

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$status"
        "[](purple)"
        "$time"
        "$username"
        "$hostname"
        "$env_var"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$rust"
        "$custom"
        "$character"
      ];

      status = {
        map_symbol = true;
        disabled = false;
        sigint_symbol = "☠";
        not_executable_symbol = "";
      };

      env_var = {
        AWS_PROFILE = {
          symbol = "☁️";
          style = "bg:blue fg:white";
          format = "[$symbol $env_value]($style)";
        };
      };

      character = {
        success_symbol = "[](blue)";
        error_symbol = "[](red)";
        vicmd_symbol = "[](blue)";
      };

      username = {
        style_user = "bg:blue fg:white";
        style_root = "bg:blue fg:red";
        format = "[$user ]($style)";
      };

      hostname = {
        format = "[$ssh_symbol$hostname ]($style)";
        style = "";
      };

      directory = {
        style = "bg:blue fg:white";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";

        substitutions = {
          "Documents" = " ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:bright-blue fg:white";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:bright-blue fg:white";
        format = "[$all_status$ahead_behind ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:blue fg:white";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:blue fg:white";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:purple fg:white";
        format = "[ $time ]($style)";
      };

      custom.task_count_pending = {
        command = "task count rc.gc=off rc.verbose=nothing status:pending";
        when = "which task";
        symbol = " ";
        style = "bg:yellow";
        description = "Count of pending Taskwarrior tasks";
      };
    };
  };
}
