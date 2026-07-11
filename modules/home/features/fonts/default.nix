{ self, inputs, ... }: {
  flake.homeManagerModules.fonts = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.fonts;
  in {
    options.hm.fonts.enable = mkEnableOption "polices Nerd Fonts + utilitaires";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.noto
        font-awesome
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
        liberation_ttf
        fontconfig
      ];

      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "FiraCode Nerd Font" "Noto Sans Mono" ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
