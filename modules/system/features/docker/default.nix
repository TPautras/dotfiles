{ self, inputs, ... }: {
  flake.nixosModules.docker = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.docker;
  in {
    options.sys.docker = {
      enable    = mkEnableOption "Docker + Compose";
      dataRoot  = mkOption {
        type    = types.nullOr types.str;
        default = null;
        description = ''
          Docker data directory. null = défaut Docker (/var/lib/docker),
          adapté aux laptops. Mettre un chemin (ex. un HDD dédié) si besoin.
        '';
      };
    };

    config = mkIf cfg.enable {
      virtualisation.docker = {
        enable              = true;
        daemon.settings = {
          features = { buildkit = true; };
        } // (lib.optionalAttrs (cfg.dataRoot != null) {
          data-root = cfg.dataRoot;
        });
        autoPrune.enable    = true;
        autoPrune.dates     = "weekly";
      };

      environment.systemPackages = with pkgs; [
        docker-compose
        lazydocker
      ];
    };
  };
}
