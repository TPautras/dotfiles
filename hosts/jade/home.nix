{
    config,
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ../../modules/home
    ];

    home.username = lib.mkDefault "thomas";
    home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
    home.stateVersion = "24.05";

    home.packages = with pkgs; [
        neofetch
        kitty
    ];

    home.file = {

    };
    
    home.sessionVariables = {

    };

    userModules = {
        desktop = {
            waybar = {
                enable = true;
            };
            hyprland = {
                enable = true;
            };
        };

        cli.fish.enable = true;
    };

    programs.home-manager.enable = true;
}