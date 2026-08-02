{ self, inputs, ... }: {
  flake.nixosModules.greetd = { config, lib, pkgs, ... }:
  with lib; let
    cfg = config.sys.greetd;
    tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
    hyprland-session = "${config.programs.hyprland.package}/share/wayland-sessions";
  in {
    options.sys.greetd.enable = mkEnableOption "greetd";

    config = mkIf cfg.enable {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session}";
            user = "greeter";
          };
        };
      };

      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };
}
