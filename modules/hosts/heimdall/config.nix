{ self, inputs, ... }: {
  flake.nixosModules.heimdallConfig = { pkgs, lib, config, ... }: {
    networking.hostName = "heimdall";

    sys = {
      kernel.variant = "zen";
      gaming.enable  = true;
    };

    boot.loader.timeout = 0;

    time.hardwareClockInLocalTime = true;

    system.stateVersion = "25.05";
  };
}
