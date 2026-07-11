{ self, inputs, ... }: {
  flake.nixosModules.networking = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.networking;
  in {
    options.sys.networking = {
      enable      = mkEnableOption "NetworkManager + firewall";
      openPorts   = mkOption {
        type    = types.listOf types.port;
        default = [ 22 80 443 ];
        description = "TCP ports to open in the firewall.";
      };
    };

    config = mkIf cfg.enable {
      networking = {
        networkmanager.enable = true;
        firewall = {
          enable          = true;
          allowedTCPPorts = cfg.openPorts;
          allowedUDPPorts = [ 41641 ];
        };
      };

      services.avahi = {
        enable   = true;
        nssmdns4 = true;
      };

      environment.systemPackages = with pkgs; [
        networkmanager wget curl nmap dnsutils ethtool traceroute mtr
      ];
    };
  };
}
