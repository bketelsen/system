{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2
    terraform
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.git;
    userEmail = "brianjk@amazon.com";
    userName = "Brian Ketelsen";

  };
}
