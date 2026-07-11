{ self, inputs, ... }: {
  flake.nixosModules.locale = { config, lib, ... }:
  with lib; let
    cfg = config.sys.locale;
  in {
    options.sys.locale = {
      enable   = mkEnableOption "locale + timezone";
      timezone = mkOption {
        type    = types.str;
        default = "Europe/Paris";
        description = "System timezone.";
      };
    };

    config = mkIf cfg.enable {
      time.timeZone = cfg.timezone;

      i18n = {
        defaultLocale      = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS        = "fr_FR.UTF-8";
          LC_IDENTIFICATION = "fr_FR.UTF-8";
          LC_MEASUREMENT    = "fr_FR.UTF-8";
          LC_MONETARY       = "fr_FR.UTF-8";
          LC_NAME           = "fr_FR.UTF-8";
          LC_NUMERIC        = "fr_FR.UTF-8";
          LC_PAPER          = "fr_FR.UTF-8";
          LC_TELEPHONE      = "fr_FR.UTF-8";
          LC_TIME           = "fr_FR.UTF-8";
        };
      };
    };
  };
}
