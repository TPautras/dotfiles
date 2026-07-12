{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlandPlugins = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlandPlugins;
    ef  = self.lib.palette;
    hex = c: removePrefix "#" c;
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

        # Minimal config: only behaviour + colors. Geometry (panel height,
        # margins, the active-workspace preview) is left to hyprspace defaults —
        # overriding it was what collapsed the active preview to a thin line.
        settings.plugin.overview = {
          # Panel at the bottom so it no longer covers the top of the windows.
          onBottom           = true;
          centerAligned      = true;

          # Show the whole row, not just the active workspace.
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
