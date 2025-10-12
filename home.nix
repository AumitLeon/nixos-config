{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leon";
  home.homeDirectory = "/home/leon";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.zsh
    pkgs.atuin
    pkgs.starship
    pkgs.claude-code
    pkgs.gh
    pkgs.git
    pkgs.gnupg
    pkgs.pinentry
    pkgs.jq
    pkgs.fastfetch
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
  #  /etc/profiles/per-user/leon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
   enable = true;
   autosuggestion.enable = true; # Enables auto-suggestions
   syntaxHighlighting.enable = true; # Enables syntax highlighting
   shellAliases = {
    update = "sudo nixos-rebuild switch --flake /home/leon/nixos-config/#nixos";
  };
    oh-my-zsh = {
      enable = true;
      plugins = [ ];
      theme = "robbyrussell";
    };
  };

  programs.neovim = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.gh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Aumit Leon";
    userEmail = "aumitleon@gmail.com";

    signing = {
      key = "85CED8113959124F";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.fastfetch = {
    enable = true;
  };

  # Optional: Configure gpg-agent
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true; # if you want to use GPG keys for SSH
    pinentryPackage = pkgs.pinentry-curses;  # Terminal-based pinentry

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
