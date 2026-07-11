{ self, inputs, ... }: {
  flake.nixosModules.sound = { config, lib, ... }:
  with lib; let
    cfg = config.sys.sound;
  in {
    options.sys.sound.enable = mkEnableOption "PipeWire audio stack";

    config = mkIf cfg.enable {
      security.rtkit.enable = true;
      services.pipewire = {
        enable            = true;
        alsa.enable       = true;
        alsa.support32Bit = true;
        pulse.enable      = true;
        jack.enable       = true;
      };
    };
  };
}
