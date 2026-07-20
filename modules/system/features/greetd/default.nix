{ self, inputs, ... }: {
  flake.nixosModules.greetd = { config, lib, pkgs, ... }:
  with lib; let
    cfg = config.sys.greetd;
    tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
    hyprland-session = "${config.programs.hyprland.finalPackage}/share/wayland-sessions";
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

      # this is a life saver.
      # literally no documentation about this anywhere.
      # might be good to write about this...
      # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal"; # Without this errors will spam on screen
        # Without these bootlogs will spam on screen
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };
}