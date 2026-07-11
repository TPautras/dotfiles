{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
    ef  = self.lib.palette;
    hex = c: removePrefix "#" c;
  in {
    options.hm.hyprlandPlugins.enable =
      mkEnableOption "Hyprland plugins (hyprexpo overview, dynamic cursors) — built from nixpkgs to match the running Hyprland ABI";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        # Plugins MUST come from the same nixpkgs as the running Hyprland
        # (useGlobalPkgs = true guarantees this) or they fail to load with an
        # ABI/version mismatch.
        plugins = with pkgs.hyprlandPlugins; [
          hyprexpo
          hypr-dynamic-cursors
        ];

        settings = {
          # hyprexpo: workspaces overview (like GNOME/macOS expose)
          bind = [ "$mod, semicolon, hyprexpo:expo, toggle" ];

          plugin = {
            hyprexpo = {
              columns          = 3;
              gap_size         = 8;
              bg_col           = "rgb(${hex ef.bg2})";
              workspace_method = "center current";

              enable_gesture   = true;
              gesture_fingers  = 3;
              gesture_distance = 300;
              gesture_positive = true;
            };

            dynamic-cursors = {
              enabled = true;
              mode    = "tilt";
            };
          };
        };
      };
    };
  };
}
