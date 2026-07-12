{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
  in {
    options.hm.hyprlandPlugins.enable =
      mkEnableOption "Hyprland plugins (hyprspace overview, dynamic cursors) — built from nixpkgs to match the running Hyprland ABI";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        # Plugins MUST come from the same nixpkgs as the running Hyprland
        # (useGlobalPkgs = true guarantees this) or they fail to load with an
        # ABI/version mismatch. hyprexpo is NOT in nixpkgs; hyprspace is the
        # in-tree workspaces-overview equivalent.
        plugins = with pkgs.hyprlandPlugins; [
          hyprspace
          hypr-dynamic-cursors
        ];

        settings = {
          # hyprspace: workspaces overview, toggled on Super + ;
          bind = [ "$mod, semicolon, overview:toggle" ];

          plugin = {
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
