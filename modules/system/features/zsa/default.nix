{ self, inputs, ... }: {
  flake.nixosModules.zsa = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.zsa;
  in {
    options.sys.zsa = {
      enable    = mkEnableOption "Software for ZSA keyboards like the ZSA voyager";
    };

    config = mkIf cfg.enable {
      hardware.keyboard.zsa.enable = true;
      environment.systemPackages = with pkgs; [ keymapp ];
    };
  };
}
