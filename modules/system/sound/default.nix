{
    config,
    pkgs,
    lib,
    ...
}:
with lib; let
    cfg = config.sysModules.sound;
in {
    options.sysModules.sound = {
        enable = mkEnableOption "Enable default sound configuration";
        description = ''Sets up default sound services and tools'';
    };

    config = mkIf cfg.enable {
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };
}