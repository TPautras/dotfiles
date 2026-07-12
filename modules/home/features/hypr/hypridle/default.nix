{ self, inputs, ... }: {
  flake.homeManagerModules.hypridle = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hypridle;
  in {
    options.hm.hypridle.enable = mkEnableOption "Hypridle idle daemon";

    config = mkIf cfg.enable {
      services.hypridle = {
        enable   = true;
        settings = {
          general = {
            lock_cmd         = "pidof hyprlock || lockscreen";
            before_sleep_cmd = "loginctl lock-session";
          };
          listener = [
            { timeout = 600; on-timeout = "loginctl lock-session"; }
            { timeout = 1200; on-timeout = "systemctl suspend"; }
          ];
        };
      };
    };
  };
}
