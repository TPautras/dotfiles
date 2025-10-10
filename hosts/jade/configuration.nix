{ config, lib, pkgs, ... }:

{
  config = {
    systemSettings = {
      # users
      users = [ "thomas" ];
      adminUsers = [ "thomas" ];

      # hardware
      cachy = {
        enable = true;
        variant = "lto";
      };
      bluetooth.enable = true;
      powerprofiles.enable = true;
      tlp.enable = false;
      printing.enable = true;
      chromium = {
        enable = true;
      };

      # style
      stylix = {
        enable = true;
        theme = "everforest";
      };
    };

    users.users.thomas.description = "Thomas' user account";
  };
  
}