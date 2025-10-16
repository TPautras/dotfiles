{ config, lib, pkgs, ... }:

let
  cfg = config.features.desktop.waybar;

  # -------- Theme (palette + css) --------
  cssPaletteMacchiato = ''
@define-color base      #24273a;
@define-color mantle    #1e2030;
@define-color crust     #181926;
@define-color text      #cad3f5;
@define-color subtext0  #a5adcb;
@define-color subtext1  #b8c0e0;
@define-color overlay0  #6e738d;
@define-color overlay1  #8087a2;
@define-color overlay2  #939ab7;
@define-color surface0  #363a4f;
@define-color surface1  #494d64;
@define-color surface2  #5b6078;
@define-color blue      #8aadf4;
@define-color lavender  #b7bdf8;
@define-color sapphire  #7dc4e4;
@define-color sky       #91d7e3;
@define-color teal      #8bd5ca;
@define-color green     #a6da95;
@define-color yellow    #eed49f;
@define-color peach     #f5a97f;
@define-color maroon    #ee99a0;
@define-color red       #ed8796;
@define-color mauve     #c6a0f6;
@define-color pink      #f5bde6;
@define-color flamingo  #f0c6c6;
@define-color rosewater #f4dbd6;
'';

  cssStyle = ''
@import "macchiato.css";

/* ---- Compact global sizing (tunable via Nix options) ---- */
* {
  font-family: Inter, "Noto Sans", "Noto Color Emoji", sans-serif;
  font-size: ${toString cfg.fontSize}px;
  line-height: ${toString cfg.barHeight}px;
}

/* Windows (bars) */
window.top_bar, window.bottom_bar, window.left_bar {
  background: transparent;
  color: @text;
}

/* Modules: compact paddings/radii */
#bluetooth, #network, #pulseaudio, #custom-battery, #clock, #temperature,
#memory, #cpu, #disk, #backlight, #idle_inhibitor, #privacy, #custom-media,
#custom-night-mode, #custom-wifi, #custom-airplane, #custom-dunst, #custom-power,
#systemd-failed-units, #language, #mpris {
  background: @surface0;
  color: @text;
  border-radius: ${toString cfg.radius}px;
  padding: 2px 6px;
  margin: 2px 4px;
}

#taskbar button {
  background: @surface0;
  border-radius: ${toString cfg.radius}px;
  padding: 1px 4px;
  margin: 1px 3px;
  color: @subtext1;
}
#taskbar button:hover { background: @surface1; color: @text; }

/* Accents */
#custom-battery.warning { color: @peach; }
#custom-battery.critical { color: @red; }
#pulseaudio.muted { color: @overlay1; }
#network.disconnected { color: @red; }
#bluetooth.off { color: @overlay1; }
#clock { color: @mauve; }
#cpu { color: @sky; }
#memory { color: @sapphire; }
#disk { color: @teal; }
#temperature { color: @yellow; }
#backlight { color: @peach; }
#idle_inhibitor.activated { color: @green; }

/* States printed by our scripts */
#custom-wifi.off { color: @overlay0; }
#custom-airplane.on { color: @peach; }
#custom-dunst.off { color: @subtext0; }

/* Hide custom battery if not present */
#custom-battery.hidden { background: transparent; color: transparent; padding: 0; margin: 0; }
'';

  # -------- Waybar config (battery natif -> custom/battery) --------
  jsoncConfig = ''
[
  {
    "name": "top_bar",
    "height": ${toString cfg.barHeight},
    "position": "top",
    "layer": "${cfg.layer}",
    "modules-left": [ "hyprland/workspaces", "hyprland/submap", "hyprland/window" ],
    "modules-center": [ "wlr/taskbar" ],
    "modules-right": [
      "privacy", "pulseaudio", "bluetooth", "network", "custom/battery",
      "backlight", "cpu", "memory", "temperature", "disk",
      "systemd-failed-units", "clock"
    ],

    "clock": { "format": "{:%Y-%m-%d %H:%M:%S}" },

    "bluetooth": {
      "format": "{controller_alias}",
      "format-connected": "{device_alias}",
      "format-disabled": "Off",
      "on-click": "blueman-manager",
      "icon-size": ${toString cfg.iconSize}
    },

    "network": {
      "format-wifi": "{essid} ({signalStrength}%)",
      "format-ethernet": "{ifname}",
      "format-disconnected": "Disconnected",
      "on-click": "nm-connection-editor"
    },

    "pulseaudio": {
      "format": "{volume}%",
      "format-muted": "Muted",
      "scroll-step": 1,
      "on-click": "pavucontrol"
    },

    "custom/battery": {
      "interval": 5,
      "exec": "custom_battery",
      "return-type": "json",
      "format": "{}"
    },

    "backlight": { "format": "{percent}%" },
    "cpu": { "format": "{usage}%" },
    "memory": { "format": "{percentage}%" },
    "temperature": { "format": "{temperatureC}°C" },
    "disk": { "interval": 30, "format": "{free} free" },
    "systemd-failed-units": { "format": "✗ {nr_failed}" },

    "privacy": {
      "icon-size": ${toString cfg.iconSize},
      "icon-spacing": 4,
      "icon-dimmed-opacity": 0.35
    },

    "wlr/taskbar": {
      "format": "{icon} {title}",
      "icon-size": ${toString cfg.iconSize},
      "all-outputs": true
    },

    "hyprland/window": { "format": "{class} — {title}", "separate-outputs": true },
    "hyprland/workspaces": {
      "on-scroll-up": "hyprctl dispatch workspace e+1",
      "on-scroll-down": "hyprctl dispatch workspace e-1",
      "format": "{icon}"
    }
  },

  {
    "name": "bottom_bar",
    "height": ${toString cfg.barHeight},
    "position": "bottom",
    "layer": "${cfg.layer}",
    "modules-left": [
      "mpris", "custom/wifi", "custom/airplane", "custom/dunst"
    ],
    "modules-center": [],
    "modules-right": [ "hyprland/language" ],

    "mpris": {
      "format": "{player_icon} {title} — {artist}",
      "title-len": 20,
      "artist-len": 16,
      "on-click": "playerctl play-pause",
      "on-scroll-up": "playerctl next",
      "on-scroll-down": "playerctl previous"
    },

    "hyprland/language": { "format": "{}", "flags": true },

    "custom/wifi":       { "interval": 2, "exec": "wifi_status",       "on-click": "wifi_toggle",       "return-type": "text" },
    "custom/airplane":   { "interval": 2, "exec": "airplane_mode_status", "on-click": "airplane_mode_toggle", "return-type": "text" },
    "custom/dunst":      { "interval": 2, "exec": "dunst_status",      "on-click": "dunst_pause",       "return-type": "text" }
  },

  {
    "name": "left_bar",
    "width": 46,
    "position": "left",
    "layer": "bottom",
    "margin-top": 6,
    "margin-bottom": 6,
    "modules-left": [ "wlr/taskbar" ],
    "wlr/taskbar": {
      "format": "{icon}",
      "icon-size": ${toString (cfg.iconSize + 2)},
      "all-outputs": false
    }
  }
]
'';

  # --------- Helper scripts (ALL collected into one list) ---------
  helpers = with pkgs; [
    (writeShellScriptBin "wifi_status" ''
      set -e
      if ! command -v nmcli >/dev/null 2>&1; then echo "wifi: n/a"; exit 0; fi
      state="$(nmcli -t -f WIFI radio 2>/dev/null | tr '[:upper:]' '[:lower:]')"
      if [ "$state" = "enabled" ]; then echo "wifi: on"; else echo "wifi: off"; fi
    '')
    (writeShellScriptBin "wifi_toggle" ''
      set -e
      if ! command -v nmcli >/dev/null 2>&1; then exit 0; fi
      s="$(nmcli -t -f WIFI radio | tr '[:upper:]' '[:lower:]')"
      if [ "$s" = "enabled" ]; then nmcli radio wifi off; else nmcli radio wifi on; fi
    '')

    (writeShellScriptBin "airplane_mode_status" ''
      set -e
      if ! command -v rfkill >/dev/null 2>&1; then echo "air: n/a"; exit 0; fi
      if rfkill -r | tail -n +2 | awk '{print $4}' | grep -q "blocked"; then
        echo "airplane: on"
      else
        echo "airplane: off"
      fi
    '')
    (writeShellScriptBin "airplane_mode_toggle" ''
      set -e
      if ! command -v rfkill >/dev/null 2>&1; then exit 0; fi
      if rfkill -r | tail -n +2 | awk '{print $4}' | grep -q "blocked"; then
        rfkill unblock all
      else
        rfkill block all
      fi
    '')

    (writeShellScriptBin "dunst_status" ''
      set -e
      if ! command -v dunstctl >/dev/null 2>&1; then echo "dunst: n/a"; exit 0; fi
      s="$(dunstctl is-paused 2>/dev/null || echo false)"
      if [ "$s" = "true" ]; then echo "dunst: off"; else echo "dunst: on"; fi
    '')
    (writeShellScriptBin "dunst_pause" ''
      set -e
      if command -v dunstctl >/dev/null 2>&1; then dunstctl set-paused toggle; fi
    '')

    (writeShellScriptBin "bluetooth_toggle" ''
      set -e
      if command -v rfkill >/dev/null 2>&1; then
        if rfkill -r | grep -i bluetooth | awk '{print $4}' | grep -q "blocked"; then
          rfkill unblock bluetooth
        else
          rfkill block bluetooth
        fi
      fi
    '')

    (writeShellScriptBin "custom_battery" ''
      set -e
      if command -v upower >/dev/null 2>&1; then
        BAT="$(upower -e | grep -E '(battery|BAT)' | head -n1 || true)"
        if [ -n "$BAT" ]; then
          PCT="$(upower -i "$BAT" | awk '/percentage:/ {print $2}' | tr -d '%')"
          STATE="$(upower -i "$BAT" | awk '/state:/ {print $2}')"
          CLASS="ok"
          [ "$PCT" -lt 20 ] && CLASS="warning"
          [ "$PCT" -lt 10 ] && CLASS="critical"
          echo "{\"text\":\"${PCT}%\",\"class\":\"${CLASS}\",\"tooltip\":\"${STATE}\"}"
          exit 0
        fi
      fi
      SYSBAT="$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1 || true)"
      if [ -n "$SYSBAT" ]; then
        PCT="$(cat "$SYSBAT/capacity" 2>/dev/null || echo 0)"
        CLASS="ok"
        [ "$PCT" -lt 20 ] && CLASS="warning"
        [ "$PCT" -lt 10 ] && CLASS="critical"
        echo "{\"text\":\"${PCT}%\",\"class\":\"${CLASS}\"}"
        exit 0
      fi
      echo "{\"text\":\"\",\"class\":\"hidden\"}"
    '')
  ];

  # Base packages used by modules / scripts
  basePkgs = with pkgs; [
    jq pango cairo gdk-pixbuf
    noto-fonts noto-fonts-emoji
    playerctl pavucontrol iwgtk blueman networkmanager rfkill dunst
    upower coreutils gnugrep gawk findutils
  ];

in
with lib; {
  options.features.desktop.waybar = {
    enable = mkEnableOption "Waybar (Hyprland) single-file module, compact & with helpers";
    # UI tuning
    barHeight  = mkOption { type = types.int; default = 28; description = "Bar height in px"; };
    fontSize   = mkOption { type = types.int; default = 11; description = "Font size in px"; };
    iconSize   = mkOption { type = types.int; default = 16; description = "Icon size for taskbar/privacy"; };
    radius     = mkOption { type = types.int; default = 10; description = "Corner radius for pills"; };
    layer      = mkOption { type = types.enum [ "top" "bottom" ]; default = "top"; description = "Waybar layer"; };

    # Optional: replace palette via Stylix-exported CSS
    useStylixPalette = mkOption { type = types.bool; default = false; description = "Swap palette with Stylix CSS"; };
    stylixPaletteCss = mkOption { type = types.str; default = "/* put Stylix @define-color vars here */"; };
  };

  config = mkIf cfg.enable {
    programs.waybar.enable = true;

    # Deploy files
    xdg.configFile."waybar/config".text     = jsoncConfig;
    xdg.configFile."waybar/style.css".text  = cssStyle;
    xdg.configFile."waybar/macchiato.css".text =
      (if cfg.useStylixPalette then cfg.stylixPaletteCss else cssPaletteMacchiato);

    # >>> Single assignment only <<<
    home.packages = basePkgs ++ helpers;
  };
}
