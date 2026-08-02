{ self, inputs, ... }: {
  flake.nixosConfigurations.cobble = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; outputs = self; };
    modules = [
      self.nixosModules.cobbleHardware
      self.nixosModules.profileLaptop
      self.nixosModules.cobbleConfig
    ];
  };
}
