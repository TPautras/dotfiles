{ self, inputs, ... }: {
  flake.homeManagerModules.swaync = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.swaync;
    ef  = self.lib.palette;
  in {
    options.hm.swaync.enable = mkEnableOption "SwayNC notification center (Everforest)";

    config = mkIf cfg.enable {
      services.swaync = {
        enable = true;

        settings = {
          positionX = "right";
          positionY = "top";
          layer = "overlay";
          layer-shell = true;
          control-center-layer = "top";
          cssPriority = "user";

          control-center-margin-top    = 8;
          control-center-margin-bottom = 8;
          control-center-margin-right  = 8;
          control-center-margin-left   = 8;
          control-center-width  = 420;
          control-center-height = 600;

          notification-window-width = 380;
          notification-icon-size    = 48;
          notification-body-image-height = 100;
          notification-body-image-width  = 200;
          notification-inline-replies = true;

          timeout = 5;
          timeout-low = 3;
          timeout-critical = 0;

          fit-to-screen = true;
          keyboard-shortcuts = true;
          image-visibility = "when-available";
          transition-time = 200;
          hide-on-clear = false;
          hide-on-action = true;
          script-fail-notify = true;

          widgets = [ "title" "dnd" "notifications" "mpris" ];

          widget-config = {
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = "Tout effacer";
            };
            dnd = {
              text = "Ne pas déranger";
            };
            mpris = {
              image-size = 96;
              image-radius = 12;
            };
          };
        };

        style = ''
          * {
            font-family: "FiraCode Nerd Font", monospace;
            font-size: 14px;
          }

          .notification-row {
            outline: none;
          }

          .notification-row:focus,
          .notification-row:hover {
            background: ${ef.bg1};
          }

          .notification {
            background: ${ef.bg1};
            border: 1px solid ${ef.bg2};
            border-radius: 12px;
            margin: 6px 12px;
            padding: 0;
            box-shadow: none;
          }

          .notification-content {
            background: transparent;
            border-radius: 12px;
            padding: 8px;
          }

          .notification.critical {
            border: 1px solid ${ef.red};
          }

          .close-button {
            background: ${ef.red};
            color: ${ef.bg};
            border: none;
            border-radius: 100%;
            margin: 6px 6px 0 0;
            padding: 0;
            text-shadow: none;
          }

          .close-button:hover {
            background: ${ef.orange};
          }

          .notification-default-action,
          .notification-action {
            background: transparent;
            border: none;
            color: ${ef.fg};
            box-shadow: none;
            margin: 0;
            padding: 4px;
          }

          .notification-default-action {
            border-radius: 12px;
          }

          .notification-action:hover {
            background: ${ef.bg2};
            color: ${ef.aqua};
          }

          .summary {
            color: ${ef.green};
            font-size: 15px;
            font-weight: bold;
          }

          .time {
            color: ${ef.gray};
            font-size: 12px;
          }

          .body {
            color: ${ef.fg};
            font-size: 14px;
          }

          .control-center {
            background: ${ef.bg};
            border: 2px solid ${ef.green};
            border-radius: 16px;
            color: ${ef.fg};
          }

          .control-center-list {
            background: transparent;
          }

          .floating-notifications,
          .blank-window {
            background: transparent;
          }

          .widget-title {
            color: ${ef.fg};
            font-size: 16px;
            margin: 8px;
          }

          .widget-title > button {
            background: ${ef.bg2};
            border: none;
            border-radius: 10px;
            color: ${ef.fg};
            font-size: 14px;
            padding: 6px 12px;
          }

          .widget-title > button:hover {
            background: ${ef.green};
            color: ${ef.bg};
          }

          .widget-dnd {
            color: ${ef.fg};
            font-size: 14px;
            margin: 8px;
          }

          .widget-dnd > switch {
            background: ${ef.bg2};
            border: none;
            border-radius: 12px;
          }

          .widget-dnd > switch:checked {
            background: ${ef.green};
          }

          .widget-dnd > switch slider {
            background: ${ef.fg};
            border-radius: 12px;
          }

          .widget-mpris {
            background: ${ef.bg1};
            border-radius: 12px;
            color: ${ef.fg};
            margin: 8px;
          }

          .widget-mpris-player {
            padding: 8px;
          }

          .widget-mpris-title {
            color: ${ef.green};
            font-size: 15px;
            font-weight: bold;
          }

          .widget-mpris-subtitle {
            color: ${ef.gray};
            font-size: 13px;
          }
        '';
      };
    };
  };
}
