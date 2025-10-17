{
    config,
    pkgs,
    lib,
    ...
}:
with lib; let
    cfg = config.sysModules.cachyos;
in {
    options.sysModules.cachyos = {
        enable = mkEnableOption "Enable default cachyos configuration";
        description = ''Sets up default cachyos services and tools'';
    };

    config = mkIf cfg.enable {
        boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
    };
}