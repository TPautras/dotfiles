{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
    ef  = self.lib.palette;
    hex = c: removePrefix "#" c;
  in {
    options.hm.hyprlandPlugins.enable = mkEnableOption "Hyprland plugins from nixpkgs (hyprspace overview)";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        plugins = [ pkgs.hyprlandPlugins.hyprspace ];

        settings.bind = [ "$mod, semicolon, overview:toggle" ];

        settings.plugin.overview = {
          onBottom           = false;
          centerAligned      = true;

          showEmptyWorkspace = true;
          showNewWorkspace   = true;

          exitOnClick        = true;
          switchOnDrop       = true;

          panelColor              = "rgb(${hex ef.bg})";
          workspaceActiveBorder   = "rgb(${hex ef.green})";
          workspaceInactiveBorder = "rgb(${hex ef.bg2})";
        };
      };
    };
  };
}
