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

          general = {
            gaps_in               = 8;
            gaps_out              = 8;
            border_size           = 2;
            "col.active_border"   = "rgb(${hex ef.green})";
            "col.inactive_border" = "rgb(${hex ef.bg2})";
            layout                = "dwindle";
          };

          decoration = {
            rounding         = 8;
            active_opacity   = 1.0;
            inactive_opacity = 0.9;
            blur = {
              enabled = true;
              size    = 5;
              passes  = 2;
            };
            shadow = {
              enabled      = true;
              range        = 12;
              render_power = 3;
            };
          };

          animations = {
            enabled = true;
            bezier  = "ease, 0.25, 0.1, 0.25, 1.0";
            animation = [
              "windows, 1, 4, ease"
              "fade, 1, 4, ease"
              "workspaces, 1, 4, ease, slide"
            ];
          };

          input = {
            kb_layout    = "us";
            follow_mouse = 1;
            repeat_rate  = 25;
            repeat_delay = 600;
            touchpad.tap-to-click = true;
          };

          dwindle = {
            preserve_split = true;
          };

          misc = {
            force_default_wallpaper  = 0;
            disable_hyprland_logo    = true;
            disable_splash_rendering = true;
          };

          bind = [
            "$mod, Return, exec, kitty"
            "$mod, Space, exec, rofi -show drun"
            "$mod, N, exec, kitty -e nvim"
            "$mod, W, killactive"
            "$mod, T, togglefloating"
            "$mod, F, fullscreen"
            ", F11, fullscreen"
            "$mod, Escape, exec, wlogout -p layer-shell"
            "$mod, L, exec, hyprlock"
            "$mod SHIFT, M, exit"

            "$mod, V, exec, rofi-clipboard"
            "$mod SHIFT, V, exec, rofi-clipboard-del"
            "$mod SHIFT, N, exec, swaync-client -t -sw"

            "$mod, Tab, exec, rofi -show window"
            "$mod, C, exec, rofi -show calc -modi calc -no-show-match -no-sort"
            "$mod, period, exec, rofi -show emoji"
            "$mod, O, exec, rofi-obsidian"

            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            "$mod SHIFT, left, movewindow, l"
            "$mod SHIFT, right, movewindow, r"
            "$mod SHIFT, up, movewindow, u"
            "$mod SHIFT, down, movewindow, d"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"

            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"

            ", Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
            "SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"

            "$mod CTRL, space, exec, kitty --class walt -e walt"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          binde = [
            "$mod, equal, resizeactive, 50 0"
            "$mod, minus, resizeactive, -50 0"
            "$mod SHIFT, equal, resizeactive, 0 50"
            "$mod SHIFT, minus, resizeactive, 0 -50"
          ];

          bindl = [
            ", XF86AudioMute, exec, pamixer -t"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, pamixer -i 5"
            ", XF86AudioLowerVolume, exec, pamixer -d 5"
            ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ];
        };
      };

      services.hyprsunset = {
        enable = true;
        package = pkgs.hyprsunset;
        transitions = {
          sunrise = {
            calendar = "*-*-* 05:00:00";
            requests = [
              [ "temperature" "6500" ]
              [ "gamma 100" ]
            ];
          };
          sunset = {
            calendar = "*-*-* 19:00:00";
            requests = [
              [ "temperature" "3500" ]
              [ "gamma 50" ]
            ];
          };
        };
      };

      home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard
      ];
    };
  };
}
