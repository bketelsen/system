{ config, pkgs, ... }:
{
services.wordpress.sites."localhost" = {
    database = {
        createLocally = true;  # name is set to `wordpress` by default
        port = 3307;
        };
  themes = [ pkgs.wordpressPackages.themes.twentytwentytwo ];
  plugins = with pkgs.wordpressPackages.plugins; [
    antispam-bee
    opengraph
  ];
    virtualHost = {
      adminAddr = "bketelsen@gmail.com";
      serverAliases = [ "webservice5" "www.webservice5" ];
    };
  };
}
