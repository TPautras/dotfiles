---
name: nix-add-feature
description: Scaffold un nouveau feature module NixOS ou home-manager selon le pattern de ce repo (option enable + mkIf). À utiliser quand l'utilisateur veut ajouter un nouveau module/feature (système ou home) à la config.
---

# nix-add-feature

Ce repo suit un pattern strict : chaque feature est un module atomique avec une option `enable`,
importé ensuite dans un profil. Reproduis-le exactement.

Demande d'abord : (a) système ou home ? (b) le nom du feature (kebab-case) ?

## Feature système

Crée `modules/system/features/<nom>/default.nix` :

```nix
{ self, inputs, ... }: {
  flake.nixosModules.<camelName> = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.<camelName>;
  in {
    options.sys.<camelName>.enable = mkEnableOption "<description>";

    config = mkIf cfg.enable {
    };
  };
}
```

Puis importe-le et active-le dans `modules/system/profiles/workstation.nix` (ou `base.nix`) :
`imports = [ … self.nixosModules.<camelName> ]; sys.<camelName>.enable = true;`

## Feature home

Crée `modules/home/features/<nom>/default.nix` avec `flake.homeManagerModules.<camelName>`,
option `hm.<camelName>.enable`, et importe-le dans `modules/home/profiles/desktop.nix` ou `base.nix`.

## Après scaffolding

- Réutilise la palette via `self.lib.palette` plutôt que de recopier des couleurs hex.
- Pas de commentaires : le repo est volontairement sans commentaires (sauf le TODO de
  `hosts/cobble/hardware-configuration.nix`).
- Valide avec `nix flake check`.
