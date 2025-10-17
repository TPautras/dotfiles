{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  # Hostname and network
  networking.hostName = "jade";

  # --- Hyprland + Wayland setup ---
  programs.hyprland = {
    enable = true;
    # Pour utiliser la version de Hyprland fournie par NixOS
    package = pkgs.hyprland;
    xwayland.enable = true;
  };

  #Utilise greetd comme display manager (léger, compatible Wayland)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "thomas";
      };
    };
  };

  # Users
  users.users.thomas = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Thomas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  sysModules = {
    networking.enable = true;
    boot.enable = true;
    programs.enable = true;
    cachyos.enable = true;
    sound.enable = true;
    locale = "fr-workstation";
    printing.enable = true;
  };

  # Programs
  programs.firefox.enable = true;
  programs.fish.enable = true;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # System version
  system.stateVersion = "25.05";
}
