{ config, lib, pkgs, ... }:

{
  config = {
    systemSettings = {
      # users
      users = [ "thomas" ];
      adminUsers = [ "thomas" ];

      # hardware
      cachy.enable = true;
      bluetooth.enable = true;
      powerprofiles.enable = true;
      tlp.enable = false;
      printing.enable = true;
      chromium.enable = true;

      # dotfiles
      dotfilesDir = "/etc/nixos";

      # security
      security = {
        automount.enable = true;
        blocklist.enable = true;
        doas.enable = true;
        firejail.enable = false; # TODO setup firejail profiles
        firewall.enable = true;
        gpg.enable = true;
        openvpn.enable = true;
        sshd.enable = false;
      };

      # style
      stylix = {
        enable = true;
        theme = "everforest";
      };
    };

    users.users.thomas.description = "Thomas' user account";
    home-manager.users.thomas.userSettings = {
      name = "Thomas";
      email = "thomas@example.com";
    };

    ## EXTRA CONFIG GOES HERE

  };
  
}