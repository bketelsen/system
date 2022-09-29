{
  description = "nix system configurations";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://bketelsen.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "bketelsen.cachix.org-1:AaIF4STP+add8jLkiLaGQf7anCFyeKOFgLcI5cQ4nIo="
    ];
  };

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    small.url = "github:nixos/nixpkgs/nixos-unstable-small";


    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    darwin = {
      url = "github:kclejeune/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (flake-utils.lib) eachSystemMap defaultSystems;
      inherit (builtins) listToAttrs map;

      isDarwin = system: (builtins.elem system nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      # generate a base darwin configuration with the
      # specified hostname, overlays, and any extraModules applied
      mkDarwinConfig =
        { system ? "aarch64-darwin"
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , baseModules ? [
            home-manager.darwinModules.home-manager
            ./modules/darwin
          ]
        , extraModules ? [ ]
        }:
        darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = { inherit inputs nixpkgs stable; };
        };

      # generate a base nixos configuration with the
      # specified overlays, hardware modules, and any extraModules applied
      mkNixosConfig =
        { system ? "x86_64-linux"
        , nixpkgs ? inputs.nixos-unstable
        , stable ? inputs.stable
        , hardwareModules
        , baseModules ? [
            home-manager.nixosModules.home-manager
            ./modules/nixos
          ]
        , extraModules ? [ ]
        }:
        nixosSystem {
          inherit system;
          modules = baseModules ++ hardwareModules ++ extraModules;
          specialArgs = { inherit inputs nixpkgs stable; };
        };

      # generate a home-manager configuration usable on any unix system
      # with overlays and any extraModules applied
      mkHomeConfig =
        { username
        , system ? "x86_64-linux"
        , nixpkgs ? inputs.nixpkgs
        , stable ? inputs.stable
        , baseModules ? [
            ./modules/home-manager
            {
              home = {
                inherit username;
                homeDirectory = "${homePrefix system}/${username}";
                sessionVariables = {
                  NIX_PATH =
                    "nixpkgs=${nixpkgs}:stable=${stable}\${NIX_PATH:+:}$NIX_PATH";
                };
              };
            }
          ]
        , extraModules ? [ ]
        }:
        homeManagerConfiguration rec {
          pkgs = import nixpkgs {
            inherit system;
          };
          extraSpecialArgs = { inherit inputs nixpkgs stable; };
          modules = baseModules ++ extraModules ++ [ ./modules/overlays.nix ];
        };
    in
    {
      checks = listToAttrs (
        # darwin checks
        (map
          (system: {
            name = system;
            value = {
              darwin =
                self.darwinConfigurations.chapterhouse.config.system.build.toplevel;
              darwinServer =
                self.homeConfigurations.homeServerM1.activationPackage;
            };
          })
          nixpkgs.lib.platforms.darwin) ++
        # linux checks
        (map
          (system: {
            name = system;
            value = {
              nixos = self.nixosConfigurations.beast.config.system.build.toplevel;
              server = self.homeConfigurations.server.activationPackage;
            };
          })
          nixpkgs.lib.platforms.linux)
      );
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

      darwinConfigurations = {
        chapterhouse = mkDarwinConfig {
          extraModules = [
            ./profiles/personal.nix
    #        ./modules/darwin/apps.nix
          ];
        };
        work = mkDarwinConfig {
          extraModules = [
            ./profiles/work.nix
          ];
        };
      };

      nixosConfigurations = {
        beast = mkNixosConfig {
          hardwareModules = [
            ./modules/hardware/beast.nix
          ];
          extraModules = [
            ./profiles/personal.nix
          ];
        };
        kaitain = mkNixosConfig {
          hardwareModules = [
            ./modules/hardware/kaitain.nix
          ];
          extraModules = [
            ./profiles/personal.nix
          ];
        };
      };

      homeConfigurations = {
        server = mkHomeConfig {
          username = "bjk";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        homeServerM1 = mkHomeConfig {
          username = "bjk";
          system = "aarch64-darwin";
          extraModules = [ ./profiles/home-manager/personal.nix ];
        };
        workServerM1 = mkHomeConfig {
          username = "brianjk";
          system = "aarch64-darwin";
          extraModules = [ ./profiles/home-manager/work.nix ];
        };
      };

      devShells = eachSystemMap defaultSystems (system:
        let
          pkgs = import inputs.stable {
            inherit system;
            overlays = [ inputs.devshell.overlay ];
          };
          pyEnv = (pkgs.python3.withPackages
            (ps: with ps; [ black typer colorama shellingham ]));
          sysdo = pkgs.writeShellScriptBin "sysdo" ''
            cd $PRJ_ROOT && ${pyEnv}/bin/python3 bin/do.py $@
          '';
        in
        {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [
              nixfmt
              pyEnv
              rnix-lsp
              stylua
              treefmt
            ];
            commands = [{
              name = "sysdo";
              package = sysdo;
              category = "utilities";
              help = "perform actions on this repository";
            }];
          };
        }
      );
    };
}
