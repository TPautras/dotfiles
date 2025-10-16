{
    config,
    pkgs,
    lib,
    programs,
    ...
}:
with lib; let
    cfg = config.features.desktop.wayland;
in {
    options = {
        features.desktop.wayland = {
            enable = mkEnableOption "Enable Wayland desktop environment with Hyprland";
            description = ''Sets up a Wayland desktop environment using Hyprland, greetd'';
        };
    };

    config = mkIf cfg.enable {
            programs.greetd.enable = true;
            programs.greetd.defaultSession = "hyprland";
            programs.greetd.wayland = true;
            programs.greetd.autoLogin = true;
            programs.greetd.waylandCompositor = "hyprland";
            programs.greetd.waylandSession = "hyprland";
            programs.wayland.enable = true;
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