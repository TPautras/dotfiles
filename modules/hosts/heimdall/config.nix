{ self, inputs, ... }: {
  flake.nixosModules.heimdallConfig = { pkgs, lib, config, ... }: {
    networking.hostName = "heimdall";

    sys = {
      locale.timezone  = "Europe/Paris";
      kernel.variant   = "zen";
      tailscale.enable = true;
      gaming.enable    = true;
    };

    users.users.thomas = {
      isNormalUser          = true;
      description           = "Thomas";
      initialHashedPassword = "$y$j9T$wRJiLm5dSt0UNte.SS2Bl.$IwkUuGAAU8V.95DlHw8U7px8yFE8t/b.kdBdzzL7E6A";
      extraGroups           = [
        "wheel" "networkmanager" "docker" "video" "audio" "input" "gamemode"
      ];
    };

    home-manager.users.thomas.imports = [
      self.homeManagerModules.homeBase
      self.homeManagerModules.homeDesktop
    ];

    environment.systemPackages = with pkgs; [
      firefox
      kitty
    ];

    programs.firefox.enable = true;

    system.stateVersion = "25.05";
  };
}
