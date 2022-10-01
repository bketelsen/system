{ config, pkgs, ... }:
{
    # caddy
    services.caddy = {
        enable = true;
        email = "bketelsen@gmail.com";
        virtualHosts = {
            "web.brian.dev" = {
                xtraConfig = ''
                    reverse_proxy 127.0.0.1:2368
                '';
            };
        };
    };
}