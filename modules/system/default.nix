{
    pkgs,
    config,
    lib,
    ...
}:
with lib; let
    cfg = config.system.hyprland;
in {
    options.system.hyprland = {
        enable = lib.mkEnableOption "Enable Hyprland system configuration";
        description = ''Configures system settings for Hyprland'';
    };
    config = mkIf cfg.enable {
        imports = [
            ./wayland/wayland.nix
            ./hyprland/default.nix
            ./waybar/default.nix
        ];
    };
}