{ self, inputs, ... }: {
  flake.nixosConfigurations.heimdall = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      outputs = self;
    };
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules.heimdallHardware
      self.nixosModules.heimdallDisko
      self.nixosModules.profileTower
      self.nixosModules.gaming
      self.nixosModules.heimdallConfig
      self.homeManagerModules.heimdall
    ];
  };
}
