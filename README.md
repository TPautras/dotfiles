# NixOS — jade, cobble, heimdall

Config NixOS modulaire (flake-parts + import-tree) pour mes machines :

| Machine | Rôle | Profil |
|---------|------|--------|
| **jade** | laptop AMD de test | `profileLaptop` |
| **cobble** | laptop de travail quotidien | `profileLaptop` |
| **heimdall** | tour workstation + gaming | `profileTower` |

Bureau Hyprland + Waybar, thème Everforest, shell fish.

> **Granite n'est pas là-dedans.** C'est le serveur physique, sous Ubuntu Server 24.04,
> configuré de façon impérative (Coolify + Docker). Tout son setup vit dans
> [`granite/`](./granite/).

---

## Structure

```
modules/
├── flake/     outputs du flake (homeManagerModules, perSystem)
├── lib/       palette Everforest partagée
├── system/    config NixOS   → features/ (sys.*) + profiles/
├── home/      config user    → features/ (hm.*) + profiles/
└── hosts/     une machine = un dossier

nvim/          config Neovim en lua, éditable en place (pas dans le store)
wallpapers/
granite/       le serveur, hors NixOS
```

Chaque dossier de `modules/` a son propre README qui explique ses conventions.

L'idée générale : un **feature** est un bloc atomique avec un `enable`, un **profil**
compose des features, un **host** ne déclare que ce qui lui est propre.

```nix
sys.gaming.enable = true;    # feature système
hm.waybar.enable  = true;    # feature home
```

---

## Au quotidien

```bash
nrs                  # rebuild switch (abbr fish)
nrsh heimdall        # rebuild switch d'un host précis
make check           # nix flake check
```

Les raccourcis fish (`nrs`, `nfu`, `ngc`, `nrdeploy`, …) sont définis dans
[`modules/home/features/nix-aliases/`](./modules/home/features/nix-aliases/).

### Binds système dans Hyprland

`$hyper` = `Super + Alt + Ctrl + Shift`.

| Bind | Action |
|------|--------|
| `$hyper + R` | rebuild du host courant |
| `$hyper + Return` | ouvre le flake dans nvim |
| `$hyper + N` | ouvre `hosts/<host>/config.nix` sur `systemPackages` |

---

## Tester avant de déployer

```bash
nix flake check
nix eval .#nixosConfigurations.jade.config.system.build.toplevel --raw   # éval pure, rapide
nixos-rebuild build --flake .#jade                                       # build sans appliquer
sudo nixos-rebuild test --flake .#jade                                   # applique, revert au reboot
```

Idem via `make check`, `make build-jade`, `make vm-jade`.

---

## Changer le mot de passe

Le hash est unique pour toutes les machines, dans
[`modules/system/features/user/`](./modules/system/features/user/) :

```bash
mkpasswd -m sha-512    # colle le résultat dans sys.user.hashedPassword
```

---

## Claude Code

Guide d'utilisation de l'agent sur ce repo : [docs/claude-code.md](./docs/claude-code.md).
Skills NixOS custom dans [`.claude/skills/`](./.claude/skills/).
