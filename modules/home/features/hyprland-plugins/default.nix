{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
  in {
    options.hm.hyprlandPlugins.enable =
      mkEnableOption "Hyprland plugins from nixpkgs (hyprspace overview) — no source build, must match the running nixpkgs Hyprland";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        # From nixpkgs so everything comes prebuilt from cache.nixos.org.
        # Both the compositor (programs.hyprland) and this plugin resolve to the
        # same nixpkgs, so their ABI matches with no override needed.
        plugins = [ pkgs.hyprlandPlugins.hyprspace ];

        # hyprspace: workspaces overview, toggled on Super + ;
        settings.bind = [ "$mod, semicolon, overview:toggle" ];
      };
    };
  };
}
