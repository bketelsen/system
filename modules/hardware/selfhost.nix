{ config, pkgs, ... }:
{
    virtualisation.oci-containers.containers = {
        ghost = {
            image = "ghost:5.17";
            dependsOn = [ "db" ];
            environment = {
                DATABASE_HOST = "db.example.com";
                DATABASE_PORT = "3306";
            };
            ports = [ "2368:2368" ];
        };
        db = {
            image = "library/mysql:8";

        };
    };
}