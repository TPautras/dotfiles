{ self, inputs, ... }: {
  flake.nixosModules.profileLaptop = { ... }: {
    imports = [ self.nixosModules.profileWorkstation ];

    sys = {
      power.profile    = "laptop";
      user.homeModules = [ self.homeManagerModules.homeLaptop ];
    };
  };
}
