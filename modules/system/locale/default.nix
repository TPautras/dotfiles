{ config, lib, pkgs, ... }:

let
  cfg = config.sysModule.locale;
in
{
  options.sysModule.locale = lib.mkOption {
    type = lib.types.enum [ "fr-workstation" "fr-server" "fr-minimal" ];
    default = "fr-workstation";
    description = ''
      Profils préconfigurés de locale / clavier / fuseau horaire (centré France).

      - fr-workstation : oriente desktop (X activé), français principal avec clavier US.  
      - fr-server : mode serveur (pas d’interface), français principal avec clavier US.  
      - fr-minimal : configuration minimale, français seulement avec clavier US.  
    '';
  };

  config = lib.mkIf (cfg == "fr-workstation") {
    i18n.defaultLocale = "fr_FR.UTF-8";
    i18n.extraLocales = [ "en_US.UTF-8" ];   # installer cette locale additionnelle
    # si tu veux régler certaines LC manuellement :
    i18n.extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      # tu peux ajouter LC_TIME, LC_NUMERIC, etc. ici si besoin
    };
    i18n.consoleKeymap = "us";
    time.timeZone = "Asia/Seoul";

    services.xserver.enable = true;
    services.xserver.layout = "us";
  }
  // lib.mkIf (cfg == "fr-server") {
    i18n.defaultLocale = "fr_FR.UTF-8";
    i18n.extraLocales = [ "en_US.UTF-8" ];
    i18n.consoleKeymap = "us";
    time.timeZone = "Asia/Seoul";

    services.xserver.enable = false;
  }
  // lib.mkIf (cfg == "fr-minimal") {
    i18n.defaultLocale = "fr_FR.UTF-8";
    i18n.extraLocales = [];  # pas de locale additionnelle
    i18n.consoleKeymap = "us";
    time.timeZone = "Asia/Seoul";

    # pas de X, etc.
  };
}
