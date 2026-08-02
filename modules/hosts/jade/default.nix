{ self, inputs, ... }: {
  flake.nixosConfigurations.jade = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; outputs = self; };
    modules = [
      self.nixosModules.jadeHardware
      self.nixosModules.profileLaptop
      self.nixosModules.jadeConfig
    ];
  };
}
