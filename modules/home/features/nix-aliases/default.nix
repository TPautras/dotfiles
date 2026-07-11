{ self, inputs, ... }: {
  flake.homeManagerModules.nixAliases = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.nixAliases;
  in {
    options.hm.nixAliases.enable = mkEnableOption "fonctions fish pour NixOS/Nix";

    config = mkIf cfg.enable {
      programs.fish = {
        shellAbbrs = {
          nrs  = "sudo nixos-rebuild switch --flake .";
          nrt  = "sudo nixos-rebuild test --flake .";
          nrb  = "nixos-rebuild build --flake .";
          nrd  = "sudo nixos-rebuild dry-activate --flake .";
          nrbo = "sudo nixos-rebuild boot --flake .";
          nrvm = "nixos-rebuild build-vm --flake .";

          nfu  = "nix flake update";
          nfc  = "nix flake check";
          nfl  = "nix flake lock";
          nfs  = "nix flake show";

          ngc  = "sudo nix-collect-garbage -d";
          ngo  = "sudo nix store optimise";

          ndiff = "nix store diff-closures";

          nsh  = "nix shell nixpkgs#";
          nrun = "nix run nixpkgs#";
        };

        functions = {
          nrsh = {
            description = "nixos-rebuild switch sur un host précis";
            body = ''
              set host $argv[1]
              if test -z "$host"
                echo "Usage: nrsh <host>   ex: nrsh jade | nrsh cobble"
                return 1
              end
              sudo nixos-rebuild switch --flake .#$host
            '';
          };

          nrdeploy = {
            description = "nixos-rebuild switch sur un host distant via SSH";
            body = ''
              set host $argv[1]
              set ip   $argv[2]
              if test -z "$host" -o -z "$ip"
                echo "Usage: nrdeploy <host> <ip>   ex: nrdeploy cobble 100.x.y.z"
                return 1
              end
              nixos-rebuild switch --flake .#$host \
                --target-host root@$ip \
                --build-host localhost
            '';
          };

          nrvm-run = {
            description = "Build et lance une VM de test pour un host";
            body = ''
              set host $argv[1]
              if test -z "$host"
                set host jade
              end
              nixos-rebuild build-vm --flake .#$host
              echo "Lancement de la VM (Ctrl+A X pour quitter QEMU)..."
              ./result/bin/run-$host-vm
            '';
          };

          npkg = {
            description = "Recherche un paquet dans nixpkgs";
            body = ''
              nix search nixpkgs $argv[1]
            '';
          };

          nwhy = {
            description = "Affiche les dépendances inverses d'un paquet";
            body = ''
              nix why-depends /run/current-system $argv[1]
            '';
          };
        };
      };
    };
  };
}
