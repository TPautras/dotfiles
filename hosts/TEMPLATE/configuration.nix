{ config, lib, pkgs, ... }:

{
  config = {
    systemSettings = {
      # users
      users = [ "USERNAME" ];
      adminUsers = [ "USERNAME" ];

      # wm
      hyprland.enable = true;

      # style
      stylix = {
        enable = true;
        theme = "orichalcum";
      };
    };

    users.users.USERNAME.description = "NAME";
  }
  
}