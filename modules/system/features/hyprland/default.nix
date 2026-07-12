{ self, inputs, ... }: {
  flake.nixosModules.hyprland = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.hyprland;
  in {
    options.sys.hyprland = {
      enable = mkEnableOption "Hyprland Wayland compositor (system-level)";
      user   = mkOption {
        type        = types.str;
        default     = "thomas";
        description = "User pre-selected by the greeter.";
      };
    };

    config = mkIf cfg.enable {
      programs.hyprland.enable = true;

      xdg.portal = {
        enable       = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "*";
      };

      environment.systemPackages = with pkgs; [
        grim
        slurp
        wl-clipboard
        brightnessctl
        playerctl
        pamixer
        wlr-randr
      ];

      security.pam.services.hyprlock = {};
      security.polkit.enable    = true;
      services.dbus.enable      = true;
      services.upower.enable    = true;
      services.power-profiles-daemon.enable = true;

      hardware.bluetooth = {
        enable      = true;
        powerOnBoot = true;
      };
      services.blueman.enable = true;
    };
  };
}
