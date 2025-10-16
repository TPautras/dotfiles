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
            hyprland.enable = true;
            fonts.enable = true;
        };
    };
}
