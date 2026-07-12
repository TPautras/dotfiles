{ self, inputs, ... }: {
  flake.homeManagerModules.hyprland = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprland;
    ef  = self.lib.palette;
    hex = c: removePrefix "#" c;
  in {
    options.hm.hyprland.enable = mkEnableOption "Hyprland compositor (user config)";

    config = mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        enable        = true;
        package       = null;
        portalPackage = null;
        configType    = "hyprlang";

        settings = {
          "$mod" = "SUPER";

          monitor = ",preferred,auto,1";

          exec-once = [
            "waybar"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "hyprsunset"
          ];
        }
        // (import ./_appearance.nix { inherit ef hex; })
        // (import ./_input.nix)
        // (import ./_keybinds.nix);
      };

      services.hyprsunset = {
        enable  = true;
        package = pkgs.hyprsunset;
        settings.profile = [
          { time = "5:00";  temperature = 6500; gamma = 1.0; }
          { time = "19:00"; temperature = 3500; gamma = 0.5; }
        ];
      };

      home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard

        (writeShellScriptBin "toggle-retro-shader" ''
          shader="$HOME/.config/hypr/shaders/retro.frag"
          if hyprctl getoption decoration:screen_shader -j | grep -q "retro.frag"; then
            hyprctl keyword decoration:screen_shader "[[EMPTY]]"
          else
            hyprctl keyword decoration:screen_shader "$shader"
          fi
        '')
      ];

      xdg.configFile."hypr/shaders/retro.frag".text = import ./_shader.nix;
    };
  };
}
