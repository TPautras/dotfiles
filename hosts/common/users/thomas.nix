{
    config,
    pkgs,
    input,
    ...
}: {
    users.users.thomas = {
        initialHashedPassword = "$y$j9T$wRJiLm5dSt0UNte.SS2Bl.$IwkUuGAAU8V.95DlHw8U7px8yFE8t/b.kdBdzzL7E6A";
        isNormalUser = true;
        description = "Thomas";
        extraGroups = [
            "wheel"
            "networkmanager"
            "docker"
            "video"
            "audio"
            "cdrom"
            "dialout"
            "plugdev"
            "users"
            "input"
            "kvm"
            "libvirt"
            "flatpak"
            "qemu-libivirt"
        ];
        packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
    };
    home-manager.users.thomas =
        import ../../../home/thomas/${config.networking.hostName}.nix;
}