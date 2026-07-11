{ self, inputs, ... }: {
  flake.nixosModules.tailscale = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.tailscale;
  in {
    options.sys.tailscale = {
      enable    = mkEnableOption "Tailscale VPN";
      exitNode  = mkEnableOption "advertise this host as a Tailscale exit node";
    };

    config = mkIf cfg.enable {
      services.tailscale = {
        enable             = true;
        useRoutingFeatures = if cfg.exitNode then "both" else "client";
      };

      networking.firewall = {
        trustedInterfaces      = [ "tailscale0" ];
        allowedUDPPorts        = [ 41641 ];
        checkReversePath       = "loose";
      };

      environment.systemPackages = [ pkgs.tailscale ];
    };
  };
}
