{
    config,
    pkgs,
    lib,
    ...
}:
with lib; let
    cfg = config.sysModules.boot;
in {
    options.sysModules.boot = {
        enable = mkEnableOption "Enable default boot configuration";
        description = ''Sets up default boot services and tools'';
    };

    config = mkIf cfg.enable {
        # Bootloader
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
    };
}