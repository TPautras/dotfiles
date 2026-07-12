{ self, inputs, ... }: {
  flake.homeManagerModules.wallpaper = { config, pkgs, lib, ... }:
  with lib; let
    cfg  = config.hm.wallpaper;
    walt = inputs.walt.packages.${pkgs.stdenv.hostPlatform.system}.default;
    wallpaper = ../../../../../wallpapers/waterfall_1.png;
    link = "${config.home.homeDirectory}/.cache/wallpaper/current";

    setWallpaper = pkgs.writeShellScript "set-wallpaper" ''
      for _ in $(seq 1 40); do
        if ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",${wallpaper}" >/dev/null 2>&1; then
          exit 0
        fi
        sleep 0.25
      done
      echo "hyprpaper n'a pas repondu sur son IPC" >&2
      exit 1
    '';
  in {
    options.hm.wallpaper.enable = mkEnableOption "Wallpaper picker (walt) + hyprpaper backend";

    config = mkIf cfg.enable {
      services.hyprpaper = {
        enable   = true;
        settings = {
          ipc       = "on";
          splash    = false;
          preload   = [ "${wallpaper}" ];
          wallpaper = [ ",${wallpaper}" ];
        };
      };

      systemd.user.services.hyprpaper-wallpaper = {
        Unit = {
          Description = "Applique le wallpaper via IPC (hyprpaper 0.8.4 ignore preload/wallpaper de sa config)";
          After   = [ "hyprpaper.service" ];
          BindsTo = [ "hyprpaper.service" ];
          ConditionEnvironment = "WAYLAND_DISPLAY";
          X-Restart-Triggers = [ "${wallpaper}" ];
        };
        Service = {
          Type            = "oneshot";
          RemainAfterExit = true;
          ExecStart       = "${setWallpaper}";
        };
        Install.WantedBy = [ "hyprpaper.service" ];
      };

      home.packages = [ pkgs.hyprpaper walt ];

      home.activation.setupWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        WDIR="$HOME/Pictures/wallpapers"
        mkdir -p "$WDIR"
        ${pkgs.findutils}/bin/find ${../../../../../wallpapers} -maxdepth 1 -type f \
          \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
          -exec ${pkgs.coreutils}/bin/cp -n {} "$WDIR/" \;
        mkdir -p "$(dirname "${link}")"
        [ -L "${link}" ] || ln -sfn ${wallpaper} "${link}"
      '';
    };
  };
}
