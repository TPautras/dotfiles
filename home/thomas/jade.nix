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
            waybar.enable = true;
        };
    };
}
