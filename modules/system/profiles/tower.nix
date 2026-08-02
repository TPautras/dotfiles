{ self, inputs, ... }: {
  flake.nixosModules.profileTower = { ... }: {
    imports = [ self.nixosModules.profileWorkstation ];

    sys.power.profile = "desktop";
  };
}
