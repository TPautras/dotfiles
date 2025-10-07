{ lib, config, pkgs, ... }:
let
    cfg = config.systemSettings.shell;
in {
    options.systemSettings.shell = {
        enable = lib.mkEnableOption "Enable system shell configuration";

        default = lib.mkOption {
            type = lib.types.enum [ "bash" "zsh" "fish" ];
            default = "bash";
            description = "Set the default shell for users.";
        };

        enableFish = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable fish shell.";
        };

        enableZsh = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable zsh shell.";
        };

        extraShells = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of additional shells to install.";
        };
    };

    config = lib.mkIf cfg.enable {
        users.defaultUserShell = pkgs.lib.mkDefault (pkgs.lib.getAttr cfg.default pkgs);
        environment.systemPackages = with pkgs; lib.mkForce (
            [ bash ] ++
            (if cfg.enableZsh then [ zsh ] else []) ++
            (if cfg.enableFish then [ fish ] else []) ++
            (map (shell: pkgs.lib.getAttr shell pkgs) cfg.extraShells)
        );
    };
}