{ config, ... }: { 
    imports = [ 
        ./home.nix 
        ../common
        ../features/cli 
        ../features/desktop
    ]; 

    features = {
        cli = {
            fish.enable = true;
        };
        desktop = {
            wayland.enable = true;
            waybar.barHeight = 28;
            waybar.fontSize  = 11;
            waybar.iconSize  = 16;
            waybar.radius    = 10;
            waybar.enable = true;
            hyprland.enable = true;
            fonts.enable = true;
        };
    };
}
