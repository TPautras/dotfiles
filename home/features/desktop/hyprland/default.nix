{
    pkgs, ...
}:
{
    imports = [
        ./waybar.nix
        ./hyprland.nix
    ];

    home.packages = with pkgs; [
        
    ];
}