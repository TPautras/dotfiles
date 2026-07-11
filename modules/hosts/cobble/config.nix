{ self, inputs, ... }: {
  flake.nixosModules.cobbleConfig = { pkgs, lib, config, ... }: {
    networking.hostName = "cobble";

    sys = {
      locale.timezone  = "Asia/Seoul";
      kernel.variant   = "zen";
      tailscale.enable = true;
    };

    users.users.thomas = {
      isNormalUser          = true;
      description           = "Thomas";
      initialHashedPassword = "$y$j9T$wRJiLm5dSt0UNte.SS2Bl.$IwkUuGAAU8V.95DlHw8U7px8yFE8t/b.kdBdzzL7E6A";
      extraGroups           = [
        "wheel" "networkmanager" "docker" "video" "audio" "input"
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
