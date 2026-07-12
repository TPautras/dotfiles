{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg    = config.hm.hyprlandPlugins;
    system = pkgs.stdenv.hostPlatform.system;
  in {
    options.hm.hyprlandPlugins.enable =
      mkEnableOption "Hyprland plugins (hyprspace overview) — built from the hyprland flake input so it matches the running Hyprland ABI";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        # hyprspace follows the `hyprland` flake input (see flake.nix), so its
        # headers match the compositor set in the system module — no version
        # mismatch, the dispatcher registers.
        plugins = [
          inputs.hyprspace.packages.${system}.Hyprspace
        ];

        # hyprspace: workspaces overview, toggled on Super + ;
        settings.bind = [ "$mod, semicolon, overview:toggle" ];
      };
    };
  };
}
