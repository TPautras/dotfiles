{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and network
  networking.hostName = "jade";
  networking.networkmanager.enable = true;

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

  Utilise greetd comme display manager (léger, compatible Wayland)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "thomas";
      };
    };
  };

  # Wayland utilities
  environment.systemPackages = with pkgs; [
    vim
    discord
    vscode
    git
    firefox
    networkmanagerapplet
  ];

  # Sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  # Programs
  programs.firefox.enable = true;
  programs.fish.enable = true;

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # System version
  system.stateVersion = "25.05";
}
