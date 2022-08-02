{ config, lib, pkgs, ... }: {
  user.name = "brianjk";
  hm = { imports = [ ./home-manager/work.nix ]; };
}
