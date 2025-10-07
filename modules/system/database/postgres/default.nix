{ lib, config, pkgs, ... }:
let cfg = config.systemSettings.postgres;
in {
  options.systemSettings.postgres = {
    enable = lib.mkEnableOption "PostgreSQL server";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql_16;
      description = "PostgreSQL package/version.";
    };
    port = lib.mkOption { type = lib.types.int; default = 5432; };
    initialDB = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional DB to create at first start.";
    };
    authLocal = lib.mkOption {
      type = lib.types.enum [ "peer" "md5" "trust" ];
      default = "peer";
      description = "Local auth method for unix socket connections.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;
      enableTCPIP = true;
      settings.port = cfg.port;
      authentication = lib.mkForce ''
        # TYPE  DATABASE  USER  ADDRESS  METHOD
        local   all       all             ${cfg.authLocal}
        host    all       all   127.0.0.1/32  md5
        host    all       all   ::1/128       md5
      '';
      initialScript = lib.mkIf (cfg.initialDB != null) (pkgs.writeText "pg-init.sql" ''
        CREATE DATABASE "${cfg.initialDB}";
      '');
    };
    environment.systemPackages = [ cfg.package pkgs.pgcli pkgs.psqlodbc ];
  };
}
