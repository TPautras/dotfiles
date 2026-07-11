{ self, inputs, ... }: {
  flake.nixosConfigurations.cobble = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; outputs = self; };
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules.cobbleHardware
      self.nixosModules.cobbleDisko
      self.nixosModules.profileWorkstation
      self.nixosModules.cobbleConfig
    ];
  };
}
