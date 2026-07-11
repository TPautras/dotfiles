{ self, inputs, ... }: {
  flake.homeManagerModules.hyprlock = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.hyprlock;
    ef  = self.lib.palette;
    hex = c: removePrefix "#" c;

    wallpaper = ../../../../wallpapers/waterfall_1.png;

    date  = "${pkgs.coreutils}/bin/date";
    curl  = "${pkgs.curl}/bin/curl";
    tr    = "${pkgs.coreutils}/bin/tr";

    font = "FiraCode Nerd Font";
  in {
    options.hm.hyprlock.enable = mkEnableOption "Hyprlock lockscreen (Everforest)";

    config = mkIf cfg.enable {
      programs.hyprlock = {
        enable   = true;
        settings = {
          general = {
            hide_cursor        = true;
            ignore_empty_input = true;
          };

          animations = {
            enabled = true;
            bezier  = "quint, 0.22, 1.0, 0.36, 1.0";
            animation = [
              "fadeIn, 1, 3, quint"
              "fadeOut, 1, 3, quint"
              "inputFieldDots, 1, 2, quint"
            ];
          };

          background = [{
            monitor           = "";
            path              = "${wallpaper}";
            color             = "rgb(${hex ef.bg})";
            blur_size         = 4;
            blur_passes       = 3;
            noise             = 0.0117;
            contrast          = 1.3;
            brightness        = 0.8;
            vibrancy          = 0.21;
            vibrancy_darkness = 0.0;
          }];

          label = [
            {
              monitor      = "";
              text         = ''cmd[update:1000] echo "<b><big> $(${date} +%H) </big></b>"'';
              color        = "rgb(${hex ef.green})";
              font_size    = 112;
              font_family  = font;
              shadow_passes = 3;
              shadow_size   = 4;
              position     = "0, 220";
              halign       = "center";
              valign       = "center";
            }
            {
              monitor      = "";
              text         = ''cmd[update:1000] echo "<b><big> $(${date} +%M) </big></b>"'';
              color        = "rgb(${hex ef.green})";
              font_size    = 112;
              font_family  = font;
              shadow_passes = 3;
              shadow_size   = 4;
              position     = "0, 80";
              halign       = "center";
              valign       = "center";
            }
            {
              monitor     = "";
              text        = ''cmd[update:60000] echo "<b><big> $(${date} +'%A') </big></b>"'';
              color       = "rgb(${hex ef.fg})";
              font_size   = 22;
              font_family = font;
              position    = "0, 30";
              halign      = "center";
              valign      = "center";
            }
            {
              monitor     = "";
              text        = ''cmd[update:60000] echo "<b> $(${date} +'%d %b') </b>"'';
              color       = "rgb(${hex ef.fg})";
              font_size   = 18;
              font_family = font;
              position    = "0, 6";
              halign      = "center";
              valign      = "center";
            }
            {
              monitor     = "";
              text        = ''cmd[update:1800000] echo "<b>Ressenti <big>$(${curl} -s --max-time 5 'wttr.in?format=%t' | ${tr} -d '+')</big></b>"'';
              color       = "rgb(${hex ef.fg})";
              font_size   = 18;
              font_family = font;
              position    = "0, 40";
              halign      = "center";
              valign      = "bottom";
            }
          ];

          input-field = [{
            monitor           = "";
            size              = "250, 50";
            outline_thickness = 3;
            rounding          = 22;

            dots_size     = 0.26;
            dots_spacing  = 0.64;
            dots_center   = true;
            dots_rounding = -1;

            outer_color = "rgb(${hex ef.bg})";
            inner_color = "rgb(${hex ef.bg})";
            font_color  = "rgb(${hex ef.green})";
            check_color = "rgb(${hex ef.yellow})";
            fail_color  = "rgb(${hex ef.red})";

            fade_on_empty    = true;
            placeholder_text = ''<span foreground="##${hex ef.gray}"><i>Password…</i></span>'';

            position = "0, 120";
            halign   = "center";
            valign   = "bottom";
          }];
        };
      };
    };
  };
}
