{
    pkgs, ...
}:
{
    imports = [ 
        ./waybar.nix
        ./wayland.nix 
    ];

    home.packages = with pkgs; [
        
    ]
}