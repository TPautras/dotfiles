{ config, lib, pkgs, ... }:

{
  options.sysModules.locale = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Active le fuseau horaire et les réglages de locale française sur un noyau anglais.";
  };

    config = lib.mkIf config.sysModules.locale {
        time.timeZone = "Asia/Seoul";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    services.xserver.xkb = {
      layout = "us";
    };
  };
}
