{ lib,... }:
with lib; let
  cfg = config.userModules.desktop.waybar;
in
{
  options.userModules.desktop.waybar.enable = mkEnableOption "waybar config";
  config = mkIf cfg.enable {
    imports = [
      ./waybar.nix
      ./settings.nix
      ./style.nix
    ];
  };
}