{ config, pkgs, ... }:
{
    # caddy
    services.caddy = {
        enable = true;
        email = "bketelsen@gmail.com";
        virtualHosts = {
            "brian.dev" = {
                extraConfig = ''
                    reverse_proxy 127.0.0.1:2368
                '';
            };

            "www.brian.dev" = {
                extraConfig = ''
                    redir https://brian.dev{uri} permanent
                '';
            };
            "web.brian.dev" = {
                extraConfig = ''
                    reverse_proxy 127.0.0.1:2368
                '';
            };
            "joplin.ketelsen.cloud" = {
                extraConfig = ''
                    reverse_proxy 10.0.1.131:22300
                '';
            };
            "sync.brian.dev" = {
                extraConfig = ''
                    reverse_proxy 127.0.0.1:8384
                '';
            };
            "code.brian.dev" = {
                extraConfig = ''
                    reverse_proxy 10.0.1.13:3000
                '';
            };
        };
    };
}
