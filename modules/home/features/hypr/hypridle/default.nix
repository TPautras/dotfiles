{ self, inputs, ... }: {
  flake.homeManagerModules.hypridle = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hypridle;
  in {
    options.hm.hypridle = {
      enable = mkEnableOption "Hypridle idle daemon";

      lockTimeout = mkOption {
        type    = types.int;
        default = 600;
        description = "Secondes d'inactivité avant verrouillage.";
      };

      suspendTimeout = mkOption {
        type    = types.nullOr types.int;
        default = null;
        description = "Secondes avant mise en veille. null = jamais (tours, machines de jeu).";
      };
    };

    config = mkIf cfg.enable {
      services.hypridle = {
        enable   = true;
        settings = {
          general = {
            lock_cmd         = "pidof hyprlock || lockscreen";
            before_sleep_cmd = "loginctl lock-session";
          };
          listener =
            [ { timeout = cfg.lockTimeout; on-timeout = "loginctl lock-session"; } ]
            ++ optional (cfg.suspendTimeout != null) {
              timeout    = cfg.suspendTimeout;
              on-timeout = "systemctl suspend";
            };
        };
      };
    };
  };
}
