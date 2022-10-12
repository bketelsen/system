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
                 "ghost_db:/var/lib/mysql"
            ];
        };
        ghost = {
            image = "ghost:5.18.0";
            dependsOn = [ "db" ];
            environmentFiles = [
                /opt/ghost/ghost.env
            ];
            ports = [ "2368:2368" ];
            autoStart = true;
            volumes = [
                 "ghost:/var/lib/ghost/content"
            ];
        };

    };
}
