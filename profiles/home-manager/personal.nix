{ config, lib, pkgs, ... }: {
  programs.git = {
    userEmail = "bketelsen@gmail.com";
    userName = "Brian Ketelsen";
  };
}
