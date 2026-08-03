{ self, inputs, ... }: {
  flake.nixosModules.heimdallConfig =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      networking.hostName = "heimdall";

      sys = {
        kernel.variant = "zen";
        gaming.enable = true;
      };

      boot.loader.timeout = 0;

      time.hardwareClockInLocalTime = true;

      system.stateVersion = "25.05";

      user.homeModules = [ self.homeManagerModules.heimdall ];
    };
  flake.homeManagerModules.heimdall = { ... }: {
    hm.hyprland.monitors = [
      "desc:Dell Inc. DELL P2213 Y57VF2C7BPTM, 1680x1050@59.95, 0x15, 1"
      "desc:Microstep MSI G255F BC0M305706374, 1920x1080@180, 1680x0, 1"
      "desc:Microstep MSI G255F BC0M305706340, 1920x1080@180, 3600x0, 1"
    ];
    hm.hyprland.workspaceRules = [
      # Dell — gauche
      "1, monitor:desc:Dell Inc. DELL P2213 Y57VF2C7BPTM, default:true"
      "2, monitor:desc:Dell Inc. DELL P2213 Y57VF2C7BPTM"
      "3, monitor:desc:Dell Inc. DELL P2213 Y57VF2C7BPTM"
      # MSI …374 — centre
      "4, monitor:desc:Microstep MSI G255F BC0M305706374, default:true"
      "5, monitor:desc:Microstep MSI G255F BC0M305706374"
      "6, monitor:desc:Microstep MSI G255F BC0M305706374"
      # MSI …340 — droite
      "7, monitor:desc:Microstep MSI G255F BC0M305706340, default:true"
      "8, monitor:desc:Microstep MSI G255F BC0M305706340"
      "9, monitor:desc:Microstep MSI G255F BC0M305706340"
    ];
  };
}
