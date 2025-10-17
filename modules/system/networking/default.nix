{
    config,
    pkgs,
    lib,
    ...
}:
with lib; let
    cfg = config.sysModules.networking;
in {
    options.sysModules.networking = {
        enable = mkEnableOption "Enable default networking configuration";
        description = ''Sets up default networking services and tools'';
    };

    config = mkIf cfg.enable {
        networking.networkmanager.enable = true;
        networking.firewall.enable = true;
        networking.firewall.allowedTCPPorts = [ 22 80 443 ];
        networking.firewall.allowedUDPPorts = [ 1194 ];
        networking.useDHCP = true;

        services.avahi.enable = true;
        services.avahi.publishSSH = true;
        services.avahi.publishWorkstation = true;

        environment.systemPackages = with pkgs; [
            networkmanager
            openvpn
            wireguard-tools
            nmap
            wget
            curl
            net-tools
            iputils
            dnsutils
            ethtool
            traceroute
            mtr
        ];
    };
}