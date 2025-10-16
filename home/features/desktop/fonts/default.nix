{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.fonts;
in
{
    options.features.desktop.fonts = {
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
            nerd-fonts.jetbrains-mono
        ];
    };
}