{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
  in {
    options.hm.hyprlandPlugins.enable = mkEnableOption "Hyprland plugins from nixpkgs";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        plugins = with pkgs.hyprlandPlugins; [
          borders-plus-plus
          hy3
          hypr-darkwindow
          hypr-dynamic-cursors
          hyprfocus
          hyprgrass
          hyprsplit
          imgborders
        ];

        settings.plugin.dynamic-cursors = {
          enabled = true;
          mode    = "tilt";
        };
      };
    };
  };
}
