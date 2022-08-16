{ config, pkgs, lib, ... }: {
  home.file = {
    zfunc = {
      source = ./zfunc;
      target = ".zfunc";
      recursive = true;
    };
    scripts = {
      source = ./sd;
      target = "sd";
      recursive = true;
    };
    sd = {
      recursive = true;
      target = ".sd";
      source = pkgs.fetchFromGitHub {
        owner = "ianthehenry";
        repo = "sd";
        rev = "ecd1ab8d3fc3a829d8abfb8bf1e3722c9c99407b";
        sha256 = "sha256-Xh+nehM+Z4SdVns34npr6x7mdG+yyJZyWUrtcTjKoTo=";
      };
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
        rev = "3fa14a0";
        sha256 = "sha256-+jCoSx9EBLvhY9Zz41Y6cCmrSSI66Fud8rzslELOtfs=";
      };
    };
  };
}
