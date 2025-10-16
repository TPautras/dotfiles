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
            programs.greetd.sessions = {
                hyprland = {
                    command = "hyprland";
                    user = config.users.users.${config.users.defaultUser}.name;
                    env = {
                        XDG_SESSION_TYPE = "wayland";
                        XDG_CURRENT_DESKTOP = "hyprland";
                        GDK_BACKEND = "wayland";
                        QT_QPA_PLATFORM = "wayland";
                        CLUTTER_BACKEND = "wayland";
                        MOZ_ENABLE_WAYLAND = "1";
                        _JAVA_AWT_WM_NONREPARENTING = "1";
                    };
                };
            };
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