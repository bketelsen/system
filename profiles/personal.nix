{ config, lib, pkgs, ... }: {
  user.name = "bjk";
  hm = { imports = [ ./home-manager/personal.nix ]; };
}
