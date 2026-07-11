{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
  in {
    options.hm.hyprlandPlugins.enable =
      mkEnableOption "Hyprland plugins (hyprspace overview) — requires a hyprspace build matching the running Hyprland ABI";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        plugins = [ pkgs.hyprlandPlugins.hyprspace ];
        settings.bind = [ "$mod SHIFT, E, overview:toggle" ];
      };
    };
  };
}
