{ config, pkgs, lib, ... }:

let
    cfg = config.sysModules.printing;
in
{
    options = {
        sysModules.printing = {
            enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable printing/support for printers and scanners (CUPS, Avahi, HPLIP, SANE, common drivers).";
            };

            extraPackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [
                    pkgs.hplip
                    pkgs.cups-filters
                    pkgs.gutenprint
                    pkgs."sane-backends"
                    pkgs.ippusbxd
                ];
                description = "Additional packages to install when printing is enabled.";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        services.avahi.enable = true;

        # Install common printing/scanning packages
        environment.systemPackages = lib.mkIf cfg.enable cfg.extraPackages;

        # Open common ports for printing/discovery
        networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [ 631 ];    # IPP / CUPS
        networking.firewall.allowedUDPPorts = lib.mkIf cfg.enable [ 5353 ];   # mDNS / Avahi
        services.printing.browsing = true;
    };
}