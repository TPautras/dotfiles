{ self, inputs, ... }: {
  flake.homeManagerModules.wlogout = { config, pkgs, lib, ... }:
  with lib; let
    cfg   = config.hm.wlogout;
    ef    = self.lib.palette;
    icons = "${pkgs.wlogout}/share/wlogout/icons";
  in {
    options.hm.wlogout.enable = mkEnableOption "wlogout session menu (Everforest)";

    config = mkIf cfg.enable {
      programs.wlogout = {
        enable = true;

        layout = [
          {
            label   = "lock";
            action  = "lockscreen";
            text    = "Verrouiller";
            keybind = "l";
          }
          {
            label   = "logout";
            action  = "hyprctl dispatch exit";
            text    = "Déconnexion";
            keybind = "e";
          }
          {
            label   = "suspend";
            action  = "systemctl suspend";
            text    = "Veille";
            keybind = "u";
          }
          {
            label   = "hibernate";
            action  = "systemctl hibernate";
            text    = "Hibernation";
            keybind = "h";
          }
          {
            label   = "reboot";
            action  = "systemctl reboot";
            text    = "Redémarrer";
            keybind = "r";
          }
          {
            label   = "shutdown";
            action  = "systemctl poweroff";
            text    = "Éteindre";
            keybind = "s";
          }
        ];

        style = ''
          * {
            font-family: "FiraCode Nerd Font", monospace;
            font-size: 16px;
            background-image: none;
            transition: all 0.2s ease-in-out;
          }

          window {
            background-color: alpha(${ef.bg}, 0.85);
          }

          button {
            color: ${ef.fg};
            background-color: ${ef.bg1};
            border: 2px solid ${ef.bg2};
            border-radius: 16px;
            margin: 8px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
            outline-style: none;
          }

          button:focus,
          button:hover {
            color: ${ef.green};
            background-color: ${ef.bg2};
            border-color: ${ef.green};
            background-size: 30%;
          }

          #shutdown:focus,
          #shutdown:hover {
            color: ${ef.red};
            border-color: ${ef.red};
          }

          #reboot:focus,
          #reboot:hover {
            color: ${ef.orange};
            border-color: ${ef.orange};
          }

          #lock   { background-image: url("${icons}/lock.png"); }
          #logout { background-image: url("${icons}/logout.png"); }
          #suspend { background-image: url("${icons}/suspend.png"); }
          #hibernate { background-image: url("${icons}/hibernate.png"); }
          #reboot { background-image: url("${icons}/reboot.png"); }
          #shutdown { background-image: url("${icons}/shutdown.png"); }
        '';
      };
    };
  };
}
