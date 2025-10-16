{
    lib,
    pkgs,
    config,
    ...
}:
{
    imports = [
        ./wayland
        ./hyprland
    ];
}