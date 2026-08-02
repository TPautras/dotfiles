{ self, inputs, ... }: {
  flake.nixosModules.power = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.power;
  in {
    options.sys.power.profile = mkOption {
      type    = types.enum [ "laptop" "desktop" ];
      default = "laptop";
      description = "laptop = gestion batterie + profils d'alimentation. desktop = branché en permanence.";
    };

    config = {
      services.upower.enable = true;
      services.power-profiles-daemon.enable = cfg.profile == "laptop";
    };
  };
}
