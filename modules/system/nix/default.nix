{
    lib,
    config,
    pkgs,
    ...
}:
with lib; let
    cfg = config.userModules.nix;
in {
    options.userModules.nix = {
        enable = mkEnableOption "Enable default Nix configuration";
        description = ''Sets up default Nix services and tools'';
    };
    config = mkIf cfg.enable {
        nix.settings = {
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
            experimental-features = [ "nix-command" "flakes" ];
            max-jobs = 1;
            cores = 5;
        };
    };
}