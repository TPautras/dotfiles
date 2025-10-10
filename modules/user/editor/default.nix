{ lib, config, pkgs, ... }:
let 
    cfg = config.userSettings.editor;
in {
    options.userSettings.editor = {
        enable = lib.mkEnableOption "Enable user editor configuration";

        default = lib.mkOption {
            type = lib.types.enum [ "vim" "nvim" "emacs" "vscode" ];
            default = "vscode";
            description = "Set the default editor for users.";
        };

        enableVim = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable vim editor.";
        };

        enableNvim = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable neovim editor.";
        };

        enableEmacs = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable emacs editor.";
        };

        enableVscode = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable vscode editor.";
        };

        extraEditors = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of additional editors to install.";
        };
    };

    config = lib.mkIf cfg.enable {
        users.defaultEditor = pkgs.lib.mkDefault (pkgs.lib.getAttr cfg.default pkgs);
        home.packages = with pkgs; lib.mkForce (
            (if cfg.enableVim then [ vim ] else []) ++
            (if cfg.enableNvim then [ neovim ] else []) ++
            (if cfg.enableEmacs then [ emacs ] else []) ++
            (if cfg.enableVscode then [ vscode ] else []) ++
            (map (editor: pkgs.lib.getAttr editor pkgs) cfg.extraEditors)
        );
    };
}