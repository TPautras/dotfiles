{ self, inputs, ... }: {
  # TEMPLATE — à régénérer sur la machine après le premier boot du live USB :
  #   nixos-generate-config --no-filesystems --show-hardware-config
  # puis remplace availableKernelModules par ce qui est détecté.
  # Pas de fileSystems ici : disko (heimdallDisko) les fournit.
  flake.nixosModules.heimdallHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules        = [ "kvm-amd" ];
    boot.extraModulePackages  = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
