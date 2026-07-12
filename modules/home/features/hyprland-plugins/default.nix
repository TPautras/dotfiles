{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg    = config.hm.hyprlandPlugins;
    system = pkgs.stdenv.hostPlatform.system;
  in {
    options.hm.hyprlandPlugins.enable =
      mkEnableOption "Hyprland plugins (hyprspace overview, dynamic cursors) — built from the hyprland flake input so they match the running Hyprland ABI";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        # Both plugins follow the `hyprland` flake input (see flake.nix), so
        # their headers match the compositor set in the system module — no
        # version mismatch, the dispatchers register.
        plugins = [
          inputs.hyprspace.packages.${system}.Hyprspace
          inputs.hypr-dynamic-cursors.packages.${system}.hypr-dynamic-cursors
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
