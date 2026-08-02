{ self, inputs, ... }: {
  flake.nixosModules.profileWorkstation = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.profileBase
      self.nixosModules.sound
      self.nixosModules.printing
      self.nixosModules.hyprland
      self.nixosModules.power
      self.nixosModules.kernel
      self.nixosModules.tailscale
      self.nixosModules.stylix
      self.nixosModules.docker
      self.nixosModules.zen-browser
      self.nixosModules.zsa
    ];

    sys = {
      zsa.enable      = true;
      sound.enable    = true;
      printing.enable = true;
      hyprland.enable = true;
      kernel.variant   = lib.mkDefault "zen";
      tailscale.enable = true;
      stylix.enable    = true;
      docker.enable    = true;
      zen-browser.enable = true;
      user.homeModules = [ self.homeManagerModules.homeDesktop ];
    };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      firefox
      kitty
    ];
  };
}
