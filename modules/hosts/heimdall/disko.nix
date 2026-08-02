{ self, inputs, ... }: {
  # ATTENTION : disko EFFACE entièrement le disque `device` ci-dessous.
  # Vérifie le bon disque avec `lsblk` AVANT de lancer disko, et assure-toi
  # que Windows est sur un AUTRE disque physique.
  flake.nixosModules.heimdallDisko = { lib, ... }: {
    disko.devices.disk.main = {
      type   = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            size     = "1G";
            type     = "EF00";
            content = {
              type         = "filesystem";
              format       = "vfat";
              mountpoint   = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type       = "filesystem";
              format     = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
