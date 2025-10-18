{ config, pkgs, lib, inputs, ... }:
with lib; let
    cfg = config.sysModules.hyprland;
in {
    options.sysModules.hyprland = {
        enable = mkEnableOption "Enable default Hyprland configuration";
        description = ''Sets up default Hyprland services and tools'';
    };
    config = mkIf cfg.enable {
        programs.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            xwayland.enable = true;
        };

        services.greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${pkgs.hyprland}/bin/Hyprland";
                    user = "thomas";
                };
            };
        };
    };
}