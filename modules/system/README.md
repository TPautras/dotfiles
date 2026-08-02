# modules/system — config NixOS

Tout ce qui est à l'échelle machine : services, matériel, paquets système.

## features/

Un dossier = un bloc autonome, qui expose une option `sys.<nom>` et ne fait rien
tant qu'on ne l'active pas.

```nix
{ self, inputs, ... }: {
  flake.nixosModules.monTruc = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.monTruc;
  in {
    options.sys.monTruc.enable = mkEnableOption "description";
    config = mkIf cfg.enable { ... };
  };
}
```

Le nom d'attribut (`flake.nixosModules.monTruc`) est ce qu'on référence depuis un
profil via `self.nixosModules.monTruc`. Il n'a pas à correspondre au nom du dossier,
mais autant garder les deux alignés.

Quelques features qui méritent un mot :

- **`user`** — l'utilisateur principal. C'est le seul endroit où vivent le nom, le hash
  du mot de passe et les groupes. Les autres features s'ajoutent elles-mêmes aux groupes
  dont elles ont besoin (`docker` ajoute `docker`, `gaming` ajoute `gamemode`), donc pas
  besoin d'y toucher quand on active un truc.
- **`user.homeModules`** — c'est par là que les profils système injectent la config
  home-manager. La liste se concatène entre profils : base ajoute `homeBase`,
  workstation ajoute `homeDesktop`, laptop ajoute `homeLaptop`.
- **`power`** — `profile = "laptop"` active power-profiles-daemon, `"desktop"` non.
- **`greetd`** — tuigreet. Il liste les sessions depuis `programs.hyprland.package`
  et surtout pas depuis `pkgs.hyprland` : sinon le greeter lance un Hyprland différent
  de celui que la config déclare, et les plugins refusent de charger (undefined symbol).
  Le bloc `systemd.services.greetd.serviceConfig` (Type=idle, TTY*) est nécessaire pour
  que le greeter n'ait pas les logs de boot qui lui passent dessus.
- **`programs`** — active `nh`, qui gère aussi le garbage collect. C'est **le seul** GC
  de la config, `nix.gc` n'est volontairement pas utilisé pour éviter deux politiques
  de rétention contradictoires.

## profiles/

Les profils composent les features. Ils s'empilent :

```
profileBase          tous les hosts (boot, réseau, locale, user, greetd)
└── profileWorkstation   bureau Hyprland complet (son, impression, docker, stylix…)
    ├── profileLaptop        + batterie, veille auto après 20 min
    └── profileTower         + pas de veille auto, pas de power-profiles-daemon
```

`profileTower` existe parce qu'une tour qui se met en veille pendant un téléchargement
Steam ou un entraînement, c'est pénible.
