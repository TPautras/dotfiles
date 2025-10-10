{ lib, config, pkgs, ... }:
let
  cfg = config.systemSettings.chromium;
in
{
  options.systemSettings.chromium = {
    enable = lib.mkEnableOption "Chromium browser (system-wide)";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium.enable = true;
  };
}
