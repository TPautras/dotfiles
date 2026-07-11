{ self, inputs, ... }: {
  flake.homeManagerModules.waybar = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.waybar;
    ef  = self.lib.palette;
  in {
    options.hm.waybar.enable = mkEnableOption "Waybar status bar for Hyprland";

    config = mkIf cfg.enable {
      home.packages = [ pkgs.pavucontrol ];

      programs.waybar = {
        enable = true;

        settings = [
          {
            layer = "top";
            margin-top = 0;
            margin-bottom = 0;
            margin-left = 0;
            margin-right = 0;
            spacing = 0;

            modules-left = [
              "custom/appmenuicon"
              "hyprland/workspaces"
              "tray"
              "custom/empty"
            ];

            modules-center = [
              "clock"
            ];

            modules-right = [
              "custom/spotify"
              "pulseaudio"
              "network"
              "battery"
            ];

            "hyprland/workspaces" = {
              active-only = false;
              disable-scroll = false;
              all-outputs = true;
              format = "{id}";
              on-click = "activate";
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";

              persistent-workspaces = {
                "1" = [ ];
                "2" = [ ];
                "3" = [ ];
                "4" = [ ];
                "5" = [ ];
                "6" = [ ];
              };
            };

            "custom/empty" = {
              format = " ";
            };

            "custom/appmenuicon" = {
              format = "";
              on-click = "rofi -show drun";
              on-click-right = "rofi -show run";
              tooltip = true;
              tooltip-format = "Applications";
            };

            "custom/spotify" = {
              format = "  {}";
              exec = "playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null";
              exec-if = "pgrep -x playerctld || playerctl status 2>/dev/null";
              return-type = "";
              on-click = "playerctl play-pause";
              on-click-right = "playerctl next";
              on-click-middle = "playerctl previous";
              on-scroll-up = "playerctl position 5+";
              on-scroll-down = "playerctl position 5-";
              escape = true;
              max-length = 40;
              interval = 2;
              tooltip = true;
              tooltip-format = "Clic : play/pause · Droit : suivant · Milieu : précédent";
            };

            tray = {
              icon-size = 21;
              spacing = 10;
            };

            pulseaudio = {
              format = "{icon}  {volume}%";
              format-muted = "  muet";
              format-bluetooth = "{icon}  {volume}%";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [ "" "" "" ];
              };
              scroll-step = 5;
              on-click = "pamixer -t";
              on-click-right = "pavucontrol";
              on-scroll-up = "pamixer -i 5";
              on-scroll-down = "pamixer -d 5";
              tooltip = true;
              tooltip-format = "{desc} · {volume}%\nClic : muet · Droit : mixer · Molette : volume";
            };

            network = {
              interval = 5;
              format-wifi = "  {essid}";
              format-ethernet = "󰈀  {ipaddr}";
              format-linked = "󰈀  {ifname} (sans IP)";
              format-disconnected = "󰖪  déconnecté";
              max-length = 24;
              tooltip = true;
              tooltip-format = "{ifname} via {gwaddr}\n󰅧  {bandwidthUpBytes}   󰅢  {bandwidthDownBytes}";
              tooltip-format-wifi = "{essid} · {signalStrength}%\n{ipaddr}/{cidr}\n󰅧  {bandwidthUpBytes}   󰅢  {bandwidthDownBytes}";
              tooltip-format-ethernet = "{ifname}\n{ipaddr}/{cidr}\n󰅧  {bandwidthUpBytes}   󰅢  {bandwidthDownBytes}";
              tooltip-format-disconnected = "Aucune connexion\nClic : nmtui";
              on-click = "kitty --class nmtui -e nmtui";
              on-click-right = "nm-connection-editor";
            };

            battery = {
              interval = 30;
              states = {
                good = 80;
                warning = 30;
                critical = 15;
              };
              format = "{icon}  {capacity}%";
              format-charging = "󰂄  {capacity}%";
              format-plugged = "󰚥  {capacity}%";
              format-full = "󰁹  {capacity}%";
              format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
              format-time = "{H} h {M} min";
              tooltip = true;
              tooltip-format = "{capacity}% · {timeTo}\n{power} W";
            };

            clock = {
              interval = 1;
              format = "{:%H:%M}";
              format-alt = "{:%a %d %b %Y}";
              tooltip = true;
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  months   = "<span color='${ef.yellow}'><b>{}</b></span>";
                  days     = "<span color='${ef.fg}'>{}</span>";
                  weeks    = "<span color='${ef.aqua}'><b>S{}</b></span>";
                  weekdays = "<span color='${ef.orange}'><b>{}</b></span>";
                  today    = "<span color='${ef.red}'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };
          }
        ];

        style = ''
          * {
            border: none;
            border-radius: 13px;
            font-family: "FiraCode Nerd Font", monospace;
            font-size: 15px;
            min-height: 0;
          }

          window#waybar {
            background: transparent;
            color: ${ef.fg};
          }

          .modules-left,
          .modules-center,
          .modules-right {
            background: ${ef.bg1};
            border-radius: 13px;
            padding: 1px 8px;
            margin: 5px 4px 0 4px;
          }

          #workspaces button {
            padding: 0 8px;
            background: transparent;
            color: ${ef.gray};
            border-radius: 13px;
            transition: all 0.25s ease-in-out;
          }

          #workspaces button.active {
            background: ${ef.bg2};
            color: ${ef.yellow};
            min-width: 34px;
            transition: all 0.25s ease-in-out;
          }

          #workspaces button.urgent {
            background: ${ef.red};
            color: ${ef.bg};
          }

          #workspaces button:hover {
            background: ${ef.bg2};
            color: ${ef.aqua};
            box-shadow: inset 0 -2px ${ef.aqua};
          }

          #custom-appmenuicon {
            font-size: 23px;
            color: ${ef.yellow};
            padding: 1px 20px 1px 0px;
            transition: all 0.25s ease-in-out;
          }

          #custom-appmenuicon:hover {
            color: ${ef.green};
          }

          #custom-spotify,
          #pulseaudio,
          #network,
          #battery,
          #clock,
          #tray {
            padding: 1px 12px;
            color: ${ef.fg};
            border-radius: 13px;
            transition: all 0.25s ease-in-out;
          }

          #custom-spotify:hover,
          #pulseaudio:hover,
          #network:hover,
          #battery:hover,
          #clock:hover {
            background: ${ef.bg2};
            color: ${ef.aqua};
          }

          #clock {
            font-weight: bold;
          }

          #pulseaudio.muted {
            color: ${ef.red};
          }

          #network.disconnected,
          #network.linked {
            color: ${ef.red};
          }

          #battery.charging,
          #battery.plugged,
          #battery.full {
            color: ${ef.green};
          }

          #battery.warning:not(.charging) {
            color: ${ef.orange};
          }

          #battery.critical:not(.charging) {
            color: ${ef.red};
            animation-name: blink;
            animation-duration: 0.8s;
            animation-timing-function: ease-in-out;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          @keyframes blink {
            to {
              color: ${ef.bg};
              background: ${ef.red};
            }
          }

          #tray {
            padding: 1px 8px;
          }

          #tray menu {
            background: ${ef.bg1};
            color: ${ef.fg};
          }

          tooltip {
            background: ${ef.bg};
            border: 2px solid ${ef.green};
            border-radius: 10px;
          }

          tooltip label {
            color: ${ef.fg};
            padding: 4px;
          }
        '';
      };
    };
  };
}
