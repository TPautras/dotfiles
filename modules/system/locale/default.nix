{ config, lib, pkgs, ... }:

let
    cfg = config.sysModule.locale;
in
{
    options.sysModule.locale = lib.mkOption {
        type = lib.types.enum [ "fr-workstation" "fr-server" "fr-minimal" ];
        default = "fr-workstation";
        description = ''
            Preconfigured locale/keyboard/timezone profiles (French-centric).

            - fr-workstation: desktop-oriented (X enabled), French primary with US keyboard.
            - fr-server: server-oriented (no X), French primary with US keyboard.
            - fr-minimal: minimal locale setup, French only with US keyboard.
        '';
    };

    config = lib.mkIf (cfg == "fr-workstation") {
        # French as primary language, keep US keyboard, Seoul timezone
        i18n.defaultLocale = "fr_FR.UTF-8";
        i18n.supportedLocales = [ "fr_FR.UTF-8 UTF-8" "en_US.UTF-8 UTF-8" ];
        i18n.consoleKeymap = "us";
        time.timeZone = "Asia/Seoul";

        # Desktop-specific defaults
        services.xserver.enable = true;
        services.xserver.layout = "us";
    } // lib.mkIf (cfg == "fr-server") {
        # Server profile: French primary, US keyboard, Seoul timezone, no X
        i18n.defaultLocale = "fr_FR.UTF-8";
        i18n.supportedLocales = [ "fr_FR.UTF-8 UTF-8" "en_US.UTF-8 UTF-8" ];
        i18n.consoleKeymap = "us";
        time.timeZone = "Asia/Seoul";

        services.xserver.enable = false;
    } // lib.mkIf (cfg == "fr-minimal") {
        # Minimal profile: French only, US keyboard, Seoul timezone
        i18n.defaultLocale = "fr_FR.UTF-8";
        i18n.supportedLocales = [ "fr_FR.UTF-8 UTF-8" ];
        i18n.consoleKeymap = "us";
        time.timeZone = "Asia/Seoul";

        # no X, minimal extras
    };
}