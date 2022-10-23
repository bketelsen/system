{ config, pkgs, ... }:
{
services.wordpress.sites."webservice5" = {
    database.createLocally = true;  # name is set to `wordpress` by default
    themes = [ responsiveTheme ];
    plugins = [ akismetPlugin ];
    virtualHost = {
      adminAddr = "bketelsen@gmail.com";
      serverAliases = [ "webservice5" "www.webservice5" ];
    };
  };
}
