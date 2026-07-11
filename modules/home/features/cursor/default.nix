{ self, inputs, ... }: {
  flake.homeManagerModules.cursor = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.cursor;
  in {
    options.hm.cursor.enable = mkEnableOption "Bibata cursor theme";

    config = mkIf cfg.enable {
      gtk = {
        enable = true;
        cursorTheme = {
          name    = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
        };
        gtk3.extraConfig = {
          "gtk-cursor-theme-name" = "Bibata-Modern-Classic";
        };
        gtk4.extraConfig = {
          Settings = ''
            gtk-cursor-theme-name=Bibata-Modern-Classic
          '';
        };
      };

      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package    = pkgs.bibata-cursors;
        name       = "Bibata-Modern-Classic";
        size       = 16;
      };
    };
  };
}
