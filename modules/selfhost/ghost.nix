{ config, pkgs, ... }:
{
    virtualisation.oci-containers.containers = {
        db = {
            image = "mysql:8";
            ports = ["3306:3306"];
            autoStart = true;
            environment = {
                MYSQL_DATABASE = "ghost";
                MYSQL_USER = "ghost";
                MYSQL_ROOT_PASSWORD = "gh0st";
                MYSQL_PASSWORD = "gh0st";
            };
            volumes = [
                 "ghost_data:/var/lib/mysql"
            ];
        };
        ghost = {
            image = "ghost:5.17.1";
            dependsOn = [ "db" ];
            environment = {
                database__client = "mysql";
                database__connection__host = "10.0.1.118";
                database__connection__user =  "ghost";
                database__connection__password = "gh0st";
                database__connection__database =  "ghost";
                url = "https://web.brian.dev";
            };
            ports = [ "2368:2368" ];
            autoStart = true;
            volumes = [
                 "content:/var/lib/ghost/content"
            ];
        };

    };
}