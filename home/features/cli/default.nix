{ config, pkgs, ... }: {

    programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
    };

    programs.eza = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        extraOptions = ["-1" "--group-directories-first" "--icons" "--git" "-a"];
    };

    programs.bat = {
        enable = true;
    };

    home.packages = with pkgs; [
        procs
        coreutils
        tldr
        starship
        ripgrep
        fd
        fzf
        lsd
        git
        curl
        wget
        zip
        unzip
        p7zip
        zellij
        htop
        jq
        gdu
        entr
        imagemagick
    ];
}