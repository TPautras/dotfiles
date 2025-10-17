{
    config,
    pkgs,
    lib,
    programs,
    ...
}:
with lib; let
    cfg = config.userModules.desktop.wayland;
in {
    options = {
        userModules.desktop.wayland = {
            enable = mkEnableOption "Enable Wayland desktop environment with Hyprland";
            description = ''Sets up a Wayland desktop environment using Hyprland, greetd'';
        };
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            grim
            hyprlock
            qt6.qtwayland
            slurp
            waypipe
            wl-clipboard
            wofi
            wf-recorder
            wl-mirror
            wlogout
            wtype
            ydotool
        ];
    };
}