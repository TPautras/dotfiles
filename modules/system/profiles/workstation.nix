{ self, inputs, ... }: {
  flake.nixosModules.profileWorkstation = { lib, ... }: {
    imports = [
      self.nixosModules.profileBase
      self.nixosModules.sound
      self.nixosModules.printing
      self.nixosModules.hyprland
      self.nixosModules.kernel
      self.nixosModules.tailscale
      self.nixosModules.stylix
      self.nixosModules.docker
      self.nixosModules.zen-browser
    ];

    sys = {
      sound.enable    = true;
      printing.enable = true;
      hyprland = {
        enable = true;
        user   = "thomas";
      };
      kernel.variant   = lib.mkDefault "zen";
      tailscale.enable = true;
      stylix.enable    = true;
      docker.enable    = true;
      zen-browser.enable = true;
    };
  };
}
