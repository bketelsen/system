{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      "discord"
      "slack"
    ];
    masApps = { };
  };
}
