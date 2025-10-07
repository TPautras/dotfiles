{ lib, config, pkgs, ... }:
let
  cfg = config.SystemSettings.locale;
in {
    options.SystemSettings.locale = {
        enable = lib.mkEnableOption "Enable locale and timezone settings";

        timeZone = lib.mkOption {
            type = lib.types.str;
            default = "UTC";
            description = "Set the system time zone (e.g. 'Europe/Paris').";
        };

        defaultLocale = lib.mkOption {
            type = lib.types.str;
            default = "en_US.UTF-8";
            description = "Set the system locale (e.g. 'en_US.UTF-8').";
        };

        supportedLocales = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "en_US.UTF-8" "fr_FR.UTF-8" ];
            description = "List of supported locales to generate.";
        };

        consoleKeyMap = lib.mkOption {
            type = lib.types.str;
            default = "us";
            description = "Set the console keymap (e.g. 'fr' or 'us').";
        };

        enableTimesyncd = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable systemd-timesyncd to keep the system clock in sync.";
        };
    };

    config = lib.mkIf cfg.enable {
        time.timeZone = cfg.timeZone;
        services.timesyncd.enable = cfg.enableTimesyncd;
        i18n.defaultLocale = cfg.defaultLocale;
        i18n.extraLocaleSettings = {
            LC_ADDRESS = cfg.defaultLocale;
            LC_IDENTIFICATION = cfg.defaultLocale;
            LC_MEASUREMENT = cfg.defaultLocale;
            LC_MONETARY = cfg.defaultLocale;
            LC_NAME = cfg.defaultLocale;
            LC_NUMERIC = cfg.defaultLocale;
            LC_PAPER = cfg.defaultLocale;
            LC_TELEPHONE = cfg.defaultLocale;
            LC_TIME = cfg.defaultLocale;
        };
        i18n.supportedLocales = cfg.supportedLocales;
        i18n.consoleKeyMap = cfg.consoleKeyMap;
    };
}