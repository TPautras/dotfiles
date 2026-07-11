{ self, inputs, ... }: {
  flake.nixosModules.printing = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.printing;
  in {
    options.sys.printing.enable = mkEnableOption "CUPS printing + scanner support";

    config = mkIf cfg.enable {
      services.printing = {
        enable   = true;
        browsing = true;
        drivers  = with pkgs; [ hplip gutenprint ];
      };
      hardware.sane = {
        enable        = true;
        extraBackends = [ pkgs.sane-airscan ];
      };
      networking.firewall.allowedTCPPorts = [ 631 ];
      networking.firewall.allowedUDPPorts = [ 5353 ];
      environment.systemPackages = with pkgs; [ cups-filters simple-scan ];
    };
  };
}
