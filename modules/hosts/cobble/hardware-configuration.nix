{ self, inputs, ... }: {
  flake.nixosModules.cobbleHardware = { config, lib, pkgs, modulesPath, ... }: {
    # À REMPLACER sur la machine cobble : exécute `sudo nixos-generate-config`
    # puis colle le contenu de /etc/nixos/hardware-configuration.nix ici
    # (availableKernelModules, fileSystems by-uuid réels, swapDevices, microcode CPU).
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}
