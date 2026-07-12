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

        settings.plugin.overview = {
          # Panel at the bottom so it no longer covers the top of the windows.
          onBottom             = true;
          centerAligned        = true;

          # hyprspace is a single horizontal row by design; show empty/new
          # workspaces so the whole row appears, not just the active one.
          showEmptyWorkspace   = true;
          showNewWorkspace     = true;

          # Render the active workspace as a normal thumbnail like the others.
          # `true` draws it "as-is" (live) and renders broken (thin line) here.
          drawActiveWorkspace  = false;

          # Cleaner overview: drop top layers (waybar, etc.) while it's open.
          hideTopLayers        = true;
          hideBackgroundLayers = false;

          exitOnClick          = true;
          switchOnDrop         = true;
          autoScroll           = true;

          panelHeight          = 180;
          workspaceMargin      = 12;
          workspaceBorderSize  = 2;
          panelBorderWidth     = 2;

          panelColor              = "rgb(${hex ef.bg})";
          workspaceActiveBorder   = "rgb(${hex ef.green})";
          workspaceInactiveBorder = "rgb(${hex ef.bg2})";
        };
      };
    };
  };
}
