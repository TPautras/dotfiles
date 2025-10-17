{
    config,
    pkgs,
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

    config.userConfig = {
        waybar = {
            enable = true;
        };
        hyprland = {
            enable = true;
        };
    };

    programs.home-manager.enable = true;
}