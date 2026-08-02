{ self, inputs, ... }: {
  flake.nixosModules.user = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.user;
  in {
    options.sys.user = {
      name = mkOption {
        type    = types.str;
        default = "thomas";
        description = "Utilisateur principal de la machine.";
      };

      description = mkOption {
        type    = types.str;
        default = "Thomas";
      };

      hashedPassword = mkOption {
        type    = types.str;
        default = "$y$j9T$wRJiLm5dSt0UNte.SS2Bl.$IwkUuGAAU8V.95DlHw8U7px8yFE8t/b.kdBdzzL7E6A";
        description = "Hash du mot de passe initial (mkpasswd -m sha-512).";
      };

      extraGroups = mkOption {
        type    = types.listOf types.str;
        default = [ "wheel" "networkmanager" "video" "audio" "input" ];
        description = "Groupes de base. Les features ajoutent les leurs (docker, gamemode, ...).";
      };

      homeModules = mkOption {
        type    = types.listOf types.unspecified;
        default = [ ];
        description = "Modules home-manager appliqués à l'utilisateur. Les profils y ajoutent les leurs.";
      };
    };

    config = {
      users.users.${cfg.name} = {
        isNormalUser          = true;
        description           = cfg.description;
        initialHashedPassword = cfg.hashedPassword;
        extraGroups           = cfg.extraGroups;
      };

      home-manager.users.${cfg.name}.imports = cfg.homeModules;

      nix.settings.trusted-users = [ "root" cfg.name ];
    };
  };
}
