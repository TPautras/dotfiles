{ config, lib, pkgs, ... }:

let
  cfg = config.features.desktop.waybar;

  # === Contenus inline depuis tes fichiers ===
  cssPaletteMacchiato = ''
/*
*
* Catppuccin Macchiato palette
* (extracted from your macchiato.css)
* Feel free to edit/replace.
*/
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
/* style.css — imports palette then rules (from your style.css) */
@import "macchiato.css";

/* Windows */
window.top_bar,
window.bottom_bar,
window.left_bar {
  background: transparent;
  color: @text;
}

/* Modules */
#bluetooth,
#network,
#pulseaudio,
#battery,
#clock,
#temperature,
#memory,
#cpu,
#disk,
#backlight,
#idle_inhibitor,
#privacy,
#custom-media,
#custom-night-mode,
#custom-wifi,
#custom-airplane,
#custom-dunst,
#custom-power {
  background: @surface0;
  color: @text;
  border-radius: 12px;
  padding: 4px 8px;
  margin: 4px 6px;
}

/* Hover states */
#bluetooth:hover,
#network:hover,
#pulseaudio:hover,
#battery:hover,
#clock:hover,
#temperature:hover,
#memory:hover,
#cpu:hover,
#disk:hover,
#backlight:hover,
#idle_inhibitor:hover,
#privacy:hover,
#custom-media:hover,
#custom-night-mode:hover,
#custom-wifi:hover,
#custom-airplane:hover,
#custom-dunst:hover,
#custom-power:hover {
  background: @surface1;
}

/* Accents */
#battery.warning { color: @peach; }
#battery.critical { color: @red; }
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

/* Left bar task buttons */
#taskbar button {
  background: @surface0;
  border-radius: 10px;
  padding: 2px 6px;
  margin: 2px 4px;
  color: @subtext1;
}
#taskbar button:hover {
  background: @surface1;
  color: @text;
}

/* Special toggles (examples matching your config) */
#custom-night-mode.on { color: @yellow; }
#custom-wifi.off    { color: @overlay0; }
#custom-airplane.on { color: @peach; }
#custom-dunst.off   { color: @subtext0; }

#systemd-failed-units {
  color: @red;
}
'';

  jsoncConfig = ''
// Double Bar Config (from your config.txt)
[
  // Top Bar Config
  {
    "name": "top_bar",
    "height": 36,
    "position": "top",
    "layer": "top",
    "modules-left": [
      "hyprland/workspaces",
      "hyprland/submap",
      "hyprland/window"
    ],
    "modules-center": [
      "wlr/taskbar"
    ],
    "modules-right": [
      "privacy",
      "pulseaudio",
      "bluetooth",
      "network",
      "battery",
      "backlight",
      "cpu",
      "memory",
      "temperature",
      "disk",
      "systemd-failed-units",
      "clock"
    ],

    "clock": { "format": "{:%Y-%m-%d %H:%M:%S}" },
    "bluetooth": {
      "format": "{controller_alias}",
      "format-connected": "{device_alias}",
      "format-disabled": "Off",
      "on-click": "bluetooth_toggle"
    },
    "network": {
      "format-wifi": "{essid} ({signalStrength}%)",
      "format-ethernet": "{ifname}",
      "format-disconnected": "Disconnected",
      "on-click": "wifi_toggle"
    },
    "pulseaudio": {
      "format": "{volume}%",
      "format-muted": "Muted",
      "scroll-step": 1,
      "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    },
    "battery": {
      "states": { "warning": 20, "critical": 10 },
      "format": "{capacity}% {timeTo}"
    },
    "backlight": { "format": "{percent}%" },
    "cpu": { "format": "{usage}%" },
    "memory": { "format": "{percentage}%" },
    "temperature": { "format": "{temperatureC}°C" },
    "disk": { "interval": 30, "format": "{free} free" },
    "systemd-failed-units": { "format": "✗ {nr_failed}" },

    "privacy": {
      "icon-size": 20,
      "icon-spacing": 6,
      "icon-dimmed-opacity": 0.3
    },

    "wlr/taskbar": {
      "format": "{icon} {title}",
      "icon-size": 18,
      "all-outputs": true
    },

    "hyprland/window": {
      "format": "{class} — {title}",
      "separate-outputs": true
    },
    "hyprland/workspaces": {
      "on-scroll-up": "hyprctl dispatch workspace e+1",
      "on-scroll-down": "hyprctl dispatch workspace e-1",
      "format": "{icon}"
    }
  },

  // Bottom Bar Config
  {
    "name": "bottom_bar",
    "height": 36,
    "position": "bottom",
    "layer": "top",
    "modules-left": [
      "mpris",
      "custom/night-mode",
      "custom/wifi",
      "custom/airplane",
      "custom/dunst"
    ],
    "modules-center": [],
    "modules-right": [
      "hyprland/language"
    ],

    "mpris": {
      "format": "{player_icon} {title} — {artist}",
      "title-len": 20,
      "artist-len": 16,
      "on-click": "playerctl play-pause",
      "on-scroll-up": "playerctl next",
      "on-scroll-down": "playerctl previous"
    },

    "hyprland/language": {
      "format": "{}",
      "flags": true
    },

    "custom/night-mode": {
      "interval": 2,
      "exec": "night_mode_status",
      "on-click": "night_mode_toggle"
    },
    "custom/wifi": {
      "interval": 2,
      "exec": "wifi_status",
      "on-click": "wifi_toggle"
    },
    "custom/airplane": {
      "interval": 2,
      "exec": "airplane_mode_status",
      "on-click": "airplane_mode_toggle"
    },
    "custom/dunst": {
      "interval": 2,
      "exec": "dunst_status",
      "on-click": "dunst_pause"
    }
  },

  // Left Bar Config
  {
    "name": "left_bar",
    "width": 52,
    "position": "left",
    "layer": "bottom",
    "margin-top": 10,
    "margin-bottom": 10,
    "modules-left": [
      "wlr/taskbar"
    ],
    "wlr/taskbar": {
      "format": "{icon}",
      "icon-size": 22,
      "all-outputs": false
    }
  }
]
'';
in
with lib; {
  options.features.desktop.waybar = {
    enable = mkEnableOption "Waybar (Hyprland) single-file module";
    height = mkOption { type = types.int; default = 36; description = "Bar height (visual, via CSS line-height)."; };
    layer  = mkOption { type = types.enum [ "top" "bottom" ]; default = "top"; description = "Default visual layer hint."; };
    useStylixPalette = mkOption {
      type = types.bool;
      default = false;
      description = "If true, you can swap macchiato.css content with a Stylix-exported palette (edit below).";
    };
    stylixPaletteCss = mkOption {
      type = types.str;
      default = "/* Put Stylix-exported CSS palette here if you set useStylixPalette = true; */";
      description = "Raw CSS with @define-color vars compatible with style.css import.";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar.enable = true;

    # Déploie les 3 fichiers Waybar depuis ce Nix unique
    xdg.configFile."waybar/config".text = jsoncConfig;

    xdg.configFile."waybar/style.css".text = ''
${cssStyle}

/* Nix-driven tweaks */
window#waybar { /* purely visual hint if you want */
  /* layer: ${cfg.layer}; */
}
/* unify item height through line-height */
* { line-height: ${toString cfg.height}px; }
'';

    xdg.configFile."waybar/macchiato.css".text =
      (if cfg.useStylixPalette then cfg.stylixPaletteCss else cssPaletteMacchiato);

    # Dépendances utiles
    home.packages = with pkgs; [
      jq pango cairo gdk-pixbuf
      noto-fonts noto-fonts-emoji
      playerctl pavucontrol iwgtk
      # ajoute ici les outils appelés par les scripts custom si besoin
    ];
  };
}
