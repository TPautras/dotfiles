{ self, inputs, ... }: {
  flake.nixosConfigurations.jade = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; outputs = self; };
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules.jadeHardware
      self.nixosModules.jadeDisko
      self.nixosModules.profileWorkstation
      self.nixosModules.jadeConfig
    ];
  };
}
