{ lib, config, pkgs, ... }:
let cfg = config.systemSettings.hyprland;
in {
  options.systemSettings.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland (WM/DE core only)";
    withPortals = lib.mkOption { type = lib.types.bool; default = true; };
    loginManager = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "greetd" "sddm" "gdm" ]);
      default = null;
      description = "Optionally enable a display/login manager.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    xdg.portal.enable = cfg.withPortals;
    xdg.portal.extraPortals = lib.mkIf cfg.withPortals [ pkgs.xdg-desktop-portal-hyprland ];

    services.greetd.enable = (cfg.loginManager == "greetd");
    services.displayManager.sddm.enable = (cfg.loginManager == "sddm");
    services.xserver.displayManager.gdm.enable = (cfg.loginManager == "gdm");

    hardware.opengl.enable = true;
    services.libinput.enable = true;
  };
}
