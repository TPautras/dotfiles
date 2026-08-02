{ self, inputs, ... }: {
  flake.homeManagerModules.homeLaptop = { ... }: {
    hm.hypridle.suspendTimeout = 1200;
  };
}
