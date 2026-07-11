{ self, inputs, ... }: {
  flake.nixosModules.boot = { config, lib, pkgs, ... }:
  with lib; let
    cfg = config.sys.boot;
  in {
    options.sys.boot.enable = mkEnableOption "systemd-boot with silent boot and plymouth";

    config = mkIf cfg.enable {
      boot = {
        loader = {
          timeout = 0;
          systemd-boot = {
            enable             = true;
            editor             = false;
            configurationLimit = 25;
          };
          efi.canTouchEfiVariables = true;
        };

        consoleLogLevel = 3;
        initrd.verbose  = false;

        kernelParams = [
          "quiet"
          "splash"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];

        plymouth = {
          enable = true;
          theme  = "abstract_ring_alt";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "abstract_ring_alt" ];
            })
          ];
        };
      };
    };
  };
}
