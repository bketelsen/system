{ config, pkgs, ... }:
{
    virtualisation.oci-containers.containers = {
        db = {
            image = "mysql:8";
            ports = ["3306:3306"];
            autoStart = true;

        };
        ghost = {
            image = "ghost:5.17";
            dependsOn = [ "db" ];
            environment = {
                DATABASE_HOST = "db.example.com";
                DATABASE_PORT = "3306";
            };
            ports = [ "2368:2368" ];
            autoStart = true;
        };

    };
}