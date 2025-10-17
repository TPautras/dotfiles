{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  # Hostname and network
  networking.hostName = "jade";

  # Time zone and locale
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

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

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
  };

  # Printing
  services.printing.enable = true;

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
  };

  # Programs
  programs.firefox.enable = true;
  programs.fish.enable = true;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # System version
  system.stateVersion = "25.05";
}
