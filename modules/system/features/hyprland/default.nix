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
      programs.hyprland = {
        enable = true;
        # Run the flake's Hyprland so the flake-built plugins (hyprspace,
        # hypr-dynamic-cursors) match its ABI exactly.
        package       = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      };

      # Hyprland's binary cache — avoids compiling Hyprland from source.
      # extra-* appends to the defaults instead of replacing cache.nixos.org.
      nix.settings = {
        extra-substituters        = [ "https://hyprland.cachix.org" ];
        extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

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

      # Plugins are managed declaratively in home-manager
      # (modules/home/features/hyprland-plugins) so they share the exact same
      # nixpkgs/Hyprland ABI as the compositor enabled here.

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
