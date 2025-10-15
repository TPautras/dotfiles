{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let 
    cfg = config.features.cli.fish;
in {
    options = {
        features.cli.fish = {
            enable = mkEnableOption "Fish shell and related tools";
            description = ''Installs the Fish shell and related tools like Oh My Fish and Fisherman.'';
        };
    };

    config = mkIf cfg.enable {
        programs.fish = {
            enable = true;
            loginShellInit = ''
            set -x NIX_PATH nixpkgs-channel:nixos-unstable
            set -x NIX_LOG info
            set -x TERMINAL kitty
            '';
            shellAbbrs = {
                ".." = "cd ..";
                "..." = "cd ../..";
                ls = "eza --icons --group-directories-first";
                ll = "eza -la --icons --group-directories-first";
                la = "eza -a --icons --group-directories-first";
                grep = "rg";
                ps = "procs";
            };
        }
    }
}
