{
    config,
    pkgs,
    lib,
    ...
}:
with lib; let
    cfg = config.sysModules.programs;
in {
    options.sysModules.programs = {
        enable = mkEnableOption "Enable default programs";
        description = ''Sets up default programs, services and tools'';
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            vim
            discord
            vscode
            git
            firefox
            networkmanagerapplet
        ];
    };
}