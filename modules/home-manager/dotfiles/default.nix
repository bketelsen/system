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
        rev = "5f7c0de";
        sha256 = "sha256-UU4hoMn6/4f4acaEXO558O9+ZgMHwtqbfbChklOE79g=";
      };
    };
  };
}
