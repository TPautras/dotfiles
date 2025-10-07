{ lib, config, pkgs, ...}:
let cfg = config.systemSettings.printing;
in {
  options.systemSettings.printing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable printing support.";
    };

    defaultPrinter = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Set the default printer.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };
    services.printing.defaultPrinter = cfg.defaultPrinter;
  };
}