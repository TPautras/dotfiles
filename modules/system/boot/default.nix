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
        boot = {
            bootspec.enable = true;
            loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
                systemd-boot.editor = false;
            };
            consoleLogLevel = 0;
            initrd.verbose = false;
        };
    };
}