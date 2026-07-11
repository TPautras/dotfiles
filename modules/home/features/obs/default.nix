{ self, inputs, ... }: {
  flake.homeManagerModules.obs = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.obs;
  in {
    options.hm.obs.enable = mkEnableOption "OBS studio";

    config = mkIf cfg.enable {
      programs.obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vaapi #optional AMD hardware acceleration
          obs-gstreamer
          obs-vkcapture
        ];
      };
    };
  };
}
