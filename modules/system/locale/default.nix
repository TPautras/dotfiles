{ config, lib, pkgs, ... }:

let
  localeProfile = config.sysModule.locale;
in
{
  options.sysModule.locale = lib.mkOption {
    type = lib.types.enum [ "fr-workstation" "fr-server" "fr-minimal" ];
    default = "fr-workstation";
    description = ''
      Profils préconfigurés de locale / clavier / fuseau horaire :

      - fr-workstation : environnement graphique, français + clavier US  
      - fr-server : mode serveur, sans interface graphique  
      - fr-minimal : configuration minimale  
    '';
  };

  config = lib.recursiveUpdate (if localeProfile == "fr-workstation" then {
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
    services.xserver.enable = true;
    services.xserver.xkb = { layout = "us"; };
  } else if localeProfile == "fr-server" then {
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
    services.xserver.enable = false;
  } else {
    # fr-minimal
    time.timeZone = "Asia/Seoul";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-UTF-8";  # correction à “fr_FR.UTF-8”
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  }) config;
}
