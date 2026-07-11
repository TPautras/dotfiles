{ self, inputs, ... }: {
  flake.homeManagerModules.rofi = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.rofi;
    ef  = self.lib.palette;

    rofiBin = "${pkgs.rofi}/bin/rofi";

    rofiClipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
      ${pkgs.cliphist}/bin/cliphist list \
        | ${rofiBin} -dmenu -i -p "󰅌  Presse-papier" \
            -theme-str 'listview { lines: 12; }' \
        | ${pkgs.cliphist}/bin/cliphist decode \
        | ${pkgs.wl-clipboard}/bin/wl-copy
    '';

    rofiClipboardDelete = pkgs.writeShellScriptBin "rofi-clipboard-del" ''
      ${pkgs.cliphist}/bin/cliphist list \
        | ${rofiBin} -dmenu -i -p "󰩹  Supprimer" \
            -theme-str 'listview { lines: 12; } window { border-color: ${ef.red}; }' \
        | ${pkgs.cliphist}/bin/cliphist delete
    '';

    rofiObsidian = pkgs.writeShellScriptBin "rofi-obsidian" ''
      set -u
      VAULT="$HOME/.obsidian/vault"

      if [ ! -d "$VAULT" ]; then
        ${pkgs.libnotify}/bin/notify-send "rofi-obsidian" "Vault introuvable : $VAULT"
        exit 1
      fi

      SEL="$(cd "$VAULT" && ${pkgs.findutils}/bin/find . -type f -name '*.md' -printf '%P\n' \
        | ${pkgs.coreutils}/bin/sort \
        | ${rofiBin} -dmenu -i -p "󱓧  Obsidian" -theme-str 'listview { lines: 12; }')"

      [ -z "$SEL" ] && exit 0

      NOTE="''${SEL%.md}"
      VAULT_NAME="$(${pkgs.coreutils}/bin/basename "$VAULT")"
      ENCODED="$(printf '%s' "$NOTE" | ${pkgs.jq}/bin/jq -sRr @uri)"

      ${pkgs.xdg-utils}/bin/xdg-open "obsidian://open?vault=$VAULT_NAME&file=$ENCODED"
    '';
  in {
    options.hm.rofi.enable = mkEnableOption "Rofi launcher, clipboard, calc, emoji (Everforest)";

    config = mkIf cfg.enable {
      services.cliphist.enable = true;

      home.packages = [
        rofiClipboard
        rofiClipboardDelete
        rofiObsidian
        pkgs.papirus-icon-theme
      ];

      programs.rofi = {
        enable   = true;
        package  = pkgs.rofi;
        plugins  = [ pkgs.rofi-calc pkgs.rofi-emoji ];
        terminal = "${pkgs.kitty}/bin/kitty";
        font     = "FiraCode Nerd Font 12";

        extraConfig = {
          modi = "drun,run,window,calc,emoji";
          show-icons = true;
          icon-theme = "Papirus-Dark";
          drun-display-format = "{name}";
          display-drun   = "󰀻  Apps";
          display-run    = "  Run";
          display-window = "  Fenêtres";
          display-calc   = "󰪚  Calc";
          display-emoji  = "󰞅  Emoji";
          sidebar-mode = true;
          sort = true;
          matching = "fuzzy";
          drun-match-fields = "name,generic,exec,categories,keywords";
        };

        theme = builtins.toFile "everforest.rasi" ''
          * {
            bg:     ${ef.bg};
            bg-alt: ${ef.bg1};
            bg-sel: ${ef.bg2};
            fg:     ${ef.fg};
            gray:   ${ef.gray};
            green:  ${ef.green};
            aqua:   ${ef.aqua};
            yellow: ${ef.yellow};
            red:    ${ef.red};

            background-color: transparent;
            text-color:       @fg;
          }

          window {
            background-color: @bg;
            border:           2px;
            border-color:     @green;
            border-radius:    14px;
            width:            44%;
            padding:          0px;
          }

          mainbox {
            children: [ inputbar, mode-switcher, listview ];
            spacing:  10px;
            padding:  14px;
          }

          inputbar {
            background-color: @bg-alt;
            border-radius:    10px;
            padding:          10px 14px;
            spacing:          10px;
            children:         [ prompt, entry ];
          }

          prompt {
            text-color:     @green;
            vertical-align: 0.5;
          }

          entry {
            placeholder:       "Rechercher…";
            placeholder-color: @gray;
            text-color:        @fg;
            vertical-align:    0.5;
          }

          mode-switcher {
            spacing: 8px;
          }

          button {
            background-color: @bg-alt;
            text-color:       @gray;
            border-radius:    10px;
            padding:          6px;
          }

          button selected {
            background-color: @bg-sel;
            text-color:       @aqua;
          }

          listview {
            columns:      1;
            lines:        9;
            fixed-height: true;
            scrollbar:    false;
            spacing:      4px;
          }

          element {
            padding:       8px 10px;
            border-radius: 10px;
            spacing:       12px;
            children:      [ element-icon, element-text ];
          }

          element-icon {
            size:           28px;
            vertical-align: 0.5;
          }

          element-text {
            vertical-align: 0.5;
            text-color:     inherit;
          }

          element normal.normal    { text-color: @fg; }
          element alternate.normal { text-color: @fg; }

          element selected.normal {
            background-color: @bg-sel;
            text-color:       @aqua;
          }

          element.active  { text-color: @yellow; }
          element.urgent  { text-color: @red; }

          message {
            background-color: @bg-alt;
            border-radius:    10px;
            padding:          8px;
          }

          textbox {
            text-color: @fg;
          }
        '';
      };
    };
  };
}
