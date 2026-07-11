{ self, inputs, ... }: {
  flake.nixosModules.stylix = { pkgs, lib, config, options, ... }:
  with lib; let
    cfg = config.sys.stylix;
  in {
    imports = [ inputs.stylix.nixosModules.stylix ];

    options.sys.stylix.enable = mkEnableOption "Stylix theming (base16 Everforest Dark)";

    config = mkIf cfg.enable {
      stylix = {
        enable              = true;
        enableReleaseChecks = false;

        base16Scheme = {
          system  = "base16";
          name    = "Everforest Dark Hard";
          author  = "sainnhe";
          variant = "dark";
          palette = self.lib.palette.base16;
        };

        image = pkgs.runCommand "wallpaper-everforest.png" {} ''
          ${pkgs.imagemagick}/bin/convert -size 3840x2160 xc:'${self.lib.palette.bg}' "$out"
        '';

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name    = "FiraCode Nerd Font Mono";
          };
          sansSerif = {
            package = pkgs.noto-fonts;
            name    = "Noto Sans";
          };
          serif = {
            package = pkgs.noto-fonts;
            name    = "Noto Serif";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name    = "Noto Color Emoji";
          };
          sizes = {
            terminal     = 12;
            applications = 11;
            desktop      = 11;
            popups       = 11;
          };
        };

        targets = {
          gtk.enable      = true;
          gnome.enable    = false;
          qt.enable       = false;
          kmscon.enable   = false;
          plymouth.enable = false;
        };
      };
    };
  };
}
