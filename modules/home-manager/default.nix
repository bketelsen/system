{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  pyEnv =
    (pkgs.stable.python3.withPackages (ps: with ps; [ black typer colorama shellingham ]));
  sysDoNixos =
    "[[ -d /etc/nixos ]] && cd /etc/nixos && ${pyEnv}/bin/python bin/do.py $@";
  sysDoDarwin =
    "[[ -d ${homeDir}/.nixpkgs ]] && cd ${homeDir}/.nixpkgs && ${pyEnv}/bin/python bin/do.py $@";
  sysdo = (pkgs.writeShellScriptBin "sysdo" ''
    (${sysDoNixos}) || (${sysDoDarwin})
  '');

in
{
  imports = [
    ./cli
    ./dotfiles
    ./git.nix
  #  ./1password
  ];

  nixpkgs.config = {
    allowUnfree = true;

  };
  fonts.fontconfig.enable = true;

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
  };

  home =
    let
      NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
      SD_GLOBAL = "${config.home.homeDirectory}/.sd";

    in
    {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "22.05";
      sessionVariables = {
        GPG_TTY = "/dev/ttys000";
        EDITOR = "nvim";
        VISUAL = "nvim";
        CLICOLOR = 1;
        LSCOLORS = "ExFxBxDxCxegedabagacad";
        NODE_PATH = "${NODE_GLOBAL}/lib";
        # HOMEBREW_NO_AUTO_UPDATE = 1;
      };
      sessionPath = [
        "${config.home.homeDirectory}/bin"
        "${NODE_GLOBAL}/bin"
        "${config.home.homeDirectory}/.sd"
      ];

      # define package definitions for current user environment
      packages = with pkgs; [
        age
        cachix
        comma
        curl
        fd
        ffmpeg
        gawk
        gcc
        git
        gnugrep
        gnupg
        gnused
        google-cloud-sdk
        helmfile
        home-manager
        htop
        httpie
        jq
        kubectl
        kubernetes-helm
        lazygit
        luajit
        mcfly
        mmv
        ncdu
        (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
	      neovim
        nix
        nixfmt
        nixpkgs-fmt
        nodejs-18_x
        openssh
        pandoc
        parallel
        pkgs.coreutils-full
        pre-commit
        python3
        python39Packages.pip
        neofetch
        nix-prefetch
        rclone
        ripgrep
        rsync
        shellcheck
        stylua
        sysdo
        tealdeer
        terraform
        treefmt
        yarn
        yq-go
      ];
    };

}
