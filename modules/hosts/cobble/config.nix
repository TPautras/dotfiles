{ self, inputs, ... }: {
  flake.nixosModules.cobbleConfig = { pkgs, lib, config, ... }: {
    networking.hostName = "cobble";

    sys.kernel.variant = "zen";

    system.stateVersion = "25.05";
  };
}
