{
    config,
    pkgs,
    lib,
    programs,
    networking,
    ...
}:
with lib; let 
    cfg = config.features.desktop.waybar;
in {
    options = {
        features.desktop.waybar = {
            enable = mkEnableOption "Waybar, a highly customizable bar for Wayland";
            description = ''Installs and configures Waybar for Wayland desktop environments.'';
        };
    };

    config = mkIf cfg.enable {
         programs.waybar = {
    enable = true;
    style = /waybar-style.css;
    settings = let
      icons = {
        # Font Awesome icons, comments are the official icon names
        bat000 = "";  # battery-empty
        bat025 = "";  # battery-quarter
        bat050 = "";  # battery-half
        bat075 = "";  # battery-three-quarters
        bat100 = "";  # battery-full
        batPlugged = "";  # plug
        batPluggedFull = "";  # plug-circle-check
        batCharging = "";  # plug-circle-bolt
        bluetooth = "";  # bluetooth-b
        playerPlaying = "";  # play
        playerPaused = "";  # pause
        playerStopped = "";  # stop
        audioVolumeOff = ""; # volume-xmark
        audioVolumeLow = "";  # volume-low
        audioVolumeHigh = "";  # volume-high
        audioHeadphones = ""; # headphones-simple
        audioHeadset = "";  # headset
        audioMic = "";  # microphone
        audioMicOff = "";  # microphone-slash
        network = "";  # network-wired
        networkEthernet = "";  # ethernet
        networkWifi = "";  # wifi
        networkNone = "";  # square-xmark
        mode = "";  # square-plus
        presentationModeOff = "";  # eye-slash
        presentationModeOn = "";  # eye
        backlight = "";  # lightbulb
        clock = "";  # clock
        notificationsOn = "";  # bell
        notificationsOff = "";  # bell-slash
        editor = "";  # pen-to-square
        browser = "";  # globe
        firefox = "";  # firefox (firefox-browser doesn't work for some reason)
        player = "";  # music
        mail = "";  # envelope
        messenger = "";  # paper-plane
        terminal = "";  # terminal
        pdf = "";  # file-pdf
        image = "";  # image
        powerLow = "";  # moon
        powerMedium = "";  # diamond
        powerHigh = "";  # rocket
      };
      modules = {
        "sway/workspaces" = let
          /*
          - font size is 11pt, 75% of that is 8.25pt
          - so 2.75pt gap, half of that is 1.375pt
          - move up by that to center vertically
          */
          format = name: " <span size='75%' rise='1.375pt'>[${name}]</span>";
        in {
          disable-scroll = true;
          format = "<b>{name}</b>{windows}";
          format-window-separator = "";
          window-rewrite-default = format "{name}";
          window-rewrite = builtins.mapAttrs (_: value: format value) {
            "title<(.* - )?(.*) - VSCodium>" = "${icons.editor} $2";  # only use workspace name
            "title<VSCodium>" = "${icons.editor}";  # only use workspace name
            "title<.* - Vivaldi" = "${icons.browser}";
            "title<(.* — )?Mozilla Firefox>" = "${icons.firefox}";
            "title<.*YouTube Music" = "${icons.player}";
            "title<Element.*>" = "${icons.messenger}";
            "title<.* - Mozilla Thunderbird" = "${icons.mail}";
            "class<kitty> title<(.*)>" = "${icons.terminal} $1";
            "class<org.pwmt.zathura>" = "${icons.pdf}";
            "title<feh .*>" = "${icons.image}";
          };
          window-format = "this doesn't do anything but if it's not defined it doesn't work";
        };

        "sway/mode" = {
          format = "${icons.mode} {}";
          tooltip = false;
        };

        "mpris" = {
          format = "{status_icon}  {title} ({artist})";
          title-len = 16;
          artist-len = 16;
          status-icons = {
            playing = icons.playerPlaying;
            paused = icons.playerPaused;
            stopped = icons.playerStopped;
          };
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            deactivated = icons.presentationModeOff;
            activated = icons.presentationModeOn;
          };
          tooltip-format-deactivated = "Presentation mode deactivated\nDevice will idle normally";
          tooltip-format-activated = "Presentation mode activated\nDevice won't idle";
        };

        "custom/notifications" = {
          exec = pkgs.writeShellScript "waybar-notifications" ''
            mako_mode=$(makoctl mode)
            if [[ "$mako_mode" == "default" ]]; then
              echo '{ "text": "active", "alt": "activated", "class": "activated" }'
            else
              echo '{ "text": "muted", "alt": "deactivated", "class": "deactivated" }'
            fi
          '';
          return-type = "json";
          /*
          `exec-on-event` doesn't seem to work: https://github.com/Alexays/Waybar/issues/2552

          So instead we use a signal sent from the `on-click` script to update the module without
          waiting for the next interval.
          */
          signal = 1;
          interval = 30;
          on-click = pkgs.writeShellScript "waybar-toggle-notifications" ''
            makoctl mode -t do-not-disturb
            pkill --signal SIGRTMIN+1 waybar
          '';
          format = "{icon}";
          format-icons = {
            activated = icons.notificationsOn;
            deactivated = icons.notificationsOff;
          };
          tooltip-format = "Notifications {}";
        };

        "clock" = {
          format = "${icons.clock} {:%Y-%m-%d %H:%M:%S}";
          interval = 1;
        };

        "network" = {
          format = "${icons.network} {ifname}";
          format-ethernet = "${icons.networkEthernet} {ifname}";
          format-wifi = "${icons.networkWifi} {essid} ({signalStrength}%)";
          format-disconnected = "${icons.networkNone} Disconnected";
          tooltip = false;
        };

        "bluetooth" = {
          controller = networking.hostname;  # by default the controller alias is the hostname
          format = "${icons.bluetooth} {status}";
          format-on = "${icons.bluetooth} 0";
          format-connected = "${icons.bluetooth} {num_connections}";
          tooltip-format = "{controller_alias} ({controller_address})";
          tooltip-format-connected = ''
            {controller_alias} {status} ({controller_address})

            Connections:
            {device_enumerate}'';
          tooltip-format-enumerate-connected = "{device_alias} ({device_address})";
          on-click = "rofi-bluetooth";
        };

        "backlight" = {
          format = "${icons.backlight} {percent}%";
          tooltip = false;
        };

        "pulseaudio#out" = {
          format = "{icon} {volume}%";
          format-muted = "${icons.audioVolumeOff} {volume}%";
          format-icons = {
            default = [ icons.audioVolumeLow icons.audioVolumeHigh ];
            headphone = icons.audioHeadphones;
            headset = icons.audioHeadset;
          };
          on-click-right = "pavucontrol -t 3";  # opens output devices tab
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+";
          on-scroll-down = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%-";
          tooltip-format = "Device: {desc}";
        };

        "pulseaudio#in" = {
          format = "{format_source}";
          format-source = "${icons.audioMic} {volume}%";
          format-source-muted = "${icons.audioMicOff} {volume}%";
          on-click-right = "pavucontrol -t 4";  # opens input devices tab
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 1%+";
          on-scroll-down = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 1%-";
          tooltip-format = "Device: {desc}";
        };

        "battery" = {
          interval = 30;
          format = "{icon} {capacity}%";
          format-plugged = "${icons.batPlugged} {capacity}%";
          format-full = "${icons.batPluggedFull} {capacity}%";
          format-charging = "${icons.batCharging} {capacity}%";
          format-icons = [ icons.bat000 icons.bat025 icons.bat050 icons.bat075 icons.bat100 ];
          tooltip-format = "{timeTo}\nPower draw: {power} W\nHealth: {health} %\nCycles: {cycles}";
          states.warning = 15;
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Profile: {profile}\nDriver: {driver}";
          format-icons = {
            performance = icons.powerHigh;
            balanced = icons.powerMedium;
            power-saver = icons.powerLow;
          };
        };
      };
    in [
      (modules // {
        layer = "top";
        position = "top";
        height = 26;

        modules-left = [ "hypr/workspaces" "hypr/mode" ];
        modules-right = [
          "mpris"
          "idle_inhibitor"
          "custom/notifications"
          "pulseaudio#out"
          "pulseaudio#in"
          "network"
          "bluetooth"
          "backlight"
          "power-profiles-daemon"
          "battery"
          "clock"
        ];
      })
    ];
  };



        home.packages = with pkgs; [
            jq
            pango
            cairo
            gdk-pixbuf
            noto-fonts
            noto-fonts-emoji
        ];
    };
}