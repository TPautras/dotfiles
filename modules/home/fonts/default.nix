{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.userModules.desktop.fonts;
in
{
    options.userModules.desktop.fonts = {
        enable = mkEnableOption "Enable default fonts";
        description = ''Installs some default fonts'';
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            fontconfig
            font-manager
            font-awesome
            fira-code-symbols
            noto-fonts
            noto-fonts-emoji
        ];
    };
}