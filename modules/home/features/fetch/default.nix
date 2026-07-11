{ self, inputs, ... }: {
  flake.homeManagerModules.fetch = { config, pkgs, lib, inputs, ... }:
  with lib; let
    cfg = config.hm.fetch;
  in {
    imports = [ inputs.areofyl-fetch.homeManagerModules.default ]; 

    options.hm.fetch.enable = mkEnableOption "Fetch with rotating logo, a bit configured";

    config = mkIf cfg.enable {
      programs.fetch = {
        enable = true;
        labelColor = "red";
        info = [ "os" "host" "kernel" "uptime" ];
        speed = 1.0;
        spin = "xy";
      };
    };
  };
}