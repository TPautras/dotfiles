{ self, inputs, ... }: {
  flake.nixosModules.jadeConfig = { pkgs, lib, config, ... }: {
    networking.hostName = "jade";

    sys.kernel.variant = "zen";

    system.stateVersion = "25.05";
  };
}
