{ config, pkgs, lib, ... }: {
  home.file = {
    zfunc = {
      source = ./zfunc;
      target = ".zfunc";
      recursive = true;
    };
    npmrc = {
      text = ''
        prefix = ${config.home.sessionVariables.NODE_PATH};
      '';
      target = ".npmrc";
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "nixpkgs/config.nix".source = ../../config.nix;
    nvim = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "AstroNvim";
        repo = "AstroNvim";
        rev = "5dfeb77";
        sha256 = "sha256-c1FiKkVI9mQmo+ZSqt3GEP9uuITVbtwr800kBHLe1Jg=";
      };
    };
  };
}
