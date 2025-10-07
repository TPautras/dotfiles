{ lib, config, ... }:
let cfg = config.systemSettings.tailscale;
in {
  options.systemSettings.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN daemon";
    advertiseExitNode = lib.mkOption { type = lib.types.bool; default = false; };
    acceptRoutes = lib.mkOption { type = lib.types.bool; default = true; };
    useRoutingFeatures = lib.mkOption {
      type = lib.types.enum [ "none" "client" "server" ];
      default = "client";
      description = "Enable subnet router/exit node capabilities.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = cfg.useRoutingFeatures;
    services.tailscale.extraUpFlags =
      [ ] ++ lib.optional cfg.advertiseExitNode "--advertise-exit-node"
          ++ lib.optional cfg.acceptRoutes "--accept-routes";
    networking.firewall.checkReversePath = "loose";
  };
}
