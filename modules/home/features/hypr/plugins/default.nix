{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg    = config.hm.hyprlandPlugins;
    ef     = self.lib.palette;
    hex    = c: removePrefix "#" c;
    system = pkgs.stdenv.hostPlatform.system;
  in {
    options.hm.hyprlandPlugins.enable = mkEnableOption "Hyprland plugins (hyprexpo overview)";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        plugins = [ inputs.hyprexpo-nix.packages.${system}.hyprexpo ];

        settings.bind = [ "$mod, semicolon, hyprexpo:expo, toggle" ];

        settings.plugin.hyprexpo = {
          columns          = 3;
          gaps_in          = 5;
          gaps_out         = 8;
          bg_col           = "rgb(${hex ef.bg})";
          workspace_method = "center current";

          show_cursor         = 1;
          show_pinned_windows = 0;

          keynav_enable        = 1;
          keynav_wrap_h        = 1;
          keynav_wrap_v        = 1;
          keynav_reading_order = 0;

          cancel_key       = "escape";
          gesture_distance = 200;
        };
      };
    };
  };
}
