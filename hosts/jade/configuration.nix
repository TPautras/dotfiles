{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  # Hostname and network
  networking.hostName = "jade";

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
    cachyos.enable = false;
    sound.enable = true;
    locale = "fr-workstation";
    printing.enable = true;
    hyprland.enable = true;
    hyprpanel.enable = true;
  };

  # Programs
  programs.firefox.enable = true;
  programs.fish.enable = true;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # System version
  system.stateVersion = "25.05";
}
