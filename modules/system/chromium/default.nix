{ lib, config, ... }:
let cfg = config.systemSettings.chromium;
in {
  options.systemSettings.chromium = {
    enable = lib.mkEnableOption "Chromium browser (system-wide)";
    hardwareAccel = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      commandLineArgs = lib.optional cfg.hardwareAccel "--ignore-gpu-blocklist";
    };
  };
}
