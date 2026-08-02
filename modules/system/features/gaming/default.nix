{ self, inputs, ... }: {
  flake.nixosModules.gaming = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.gaming;
  in {
    options.sys.gaming.enable = mkEnableOption "Gaming (Steam, Proton-GE, gamemode, gamescope) — AMD GPU";

    config = mkIf cfg.enable {
      hardware.graphics = {
        enable      = true;
        enable32Bit = true;
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall      = true;
        dedicatedServer.openFirewall = false;
        gamescopeSession.enable      = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };

      programs.gamescope = {
        enable     = true;
        capSysNice = true;
      };

      programs.gamemode.enable = true;

      hardware.steam-hardware.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud
        protonup-qt
        lutris
        heroic
        vulkan-tools
      ];

      boot.kernel.sysctl."vm.max_map_count" = 2147483642;

      zramSwap.enable = true;
    };
  };
}
