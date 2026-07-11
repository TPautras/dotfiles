{ self, inputs, ... }: {
  flake.homeManagerModules.kitty = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.kitty;
  in {
    options.hm.kitty.enable = mkEnableOption "Kitty terminal";

    config = mkIf cfg.enable {
      programs.kitty = {
        enable    = true;
        font.name = "FiraCode Nerd Font Mono";
        font.size = 12;
        settings  = {
          window_padding_width    = 8;
          confirm_os_window_close = 0;
          enable_audio_bell       = false;
          background_opacity      = lib.mkForce "0.95";
        };
      };
    };
  };
}
