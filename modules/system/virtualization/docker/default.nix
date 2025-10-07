{ lib, config, pkgs, ... }:
let cfg = config.systemSettings.docker;
in {
  options.systemSettings.docker = {
    enable = lib.mkEnableOption "Docker engine (systemd service)";
    groupMembers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users to add to the docker group.";
    };
    enableCompose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install docker-compose (v2 CLI plugin).";
    };
    rootless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable rootless Docker (experimental; not both root+rootless).";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = !cfg.rootless;
      enableOnBoot = true;
      daemon.settings = { };
    };
    virtualisation.docker.rootless = lib.mkIf cfg.rootless { enable = true; };
    users.groups.docker.members = cfg.groupMembers;
    environment.systemPackages = lib.optional cfg.enableCompose pkgs.docker-compose;
  };
}
