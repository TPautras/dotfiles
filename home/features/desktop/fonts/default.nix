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
            ttf-jetbrains-mono
            ttf-fira-code
            ttf-iosevka
            ttf-roboto
            ttf-dejavu
            ttf-liberation
            ttf-ubuntu-font-family
            wqy-microhei
            wqy-zenhei
            xorg.fonts.misc
            xorg.fonts.cyrillic
            xorg.fonts.type1
            xorg.fonts.scaleable
        ];
    };
}