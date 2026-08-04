{ self, inputs, ... }: {
  flake.nixosModules.profileTower = { pkgs, ... }: {
    imports = [ self.nixosModules.profileWorkstation ];

    sys.power.profile = "desktop";

    # Écrans externes : la luminosité se pilote en DDC/CI (bus i2c).
    # i2c.enable charge i2c-dev + pose les règles udev/groupe pour /dev/i2c-*.
    # ddcutil fait le dialogue ; le script `brightness` s'en sert (les MSI en
    # HDMI exigent --sleep-multiplier, d'où l'abandon du module noyau ddcci).
    hardware.i2c.enable        = true;
    environment.systemPackages = [ pkgs.ddcutil ];
  };
}
