# NixOS Config — laptops Jade & Cobble

Config NixOS modulaire (flake-parts + import-tree) pour les **laptops** :

- **Jade** — laptop AMD de test, desktop **Hyprland + Waybar** (Everforest via Stylix)
- **Cobble** — laptop de travail quotidien, même stack que Jade

> **Le serveur Granite n'est pas sous NixOS.** Il tourne sous Ubuntu Server 24.04 LTS,
> configuré de façon impérative (Coolify + Docker + Hermes). Tout son setup vit dans
> [`granite/`](./granite/) — voir [granite/README.md](./granite/README.md).
1a7a0070c28742f1a1248b8d89e71999
---

## Architecture

```
modules/
├── flake/
│   ├── home-manager-output.nix   # déclare l'output homeManagerModules
│   └── systems.nix               # perSystem : formatter + packages
├── lib/
│   └── palette.nix               # palette Everforest centralisée (flake.lib.palette)
├── system/
│   ├── features/                 # modules atomiques ON/OFF (sys.*)
│   │   ├── boot networking locale sound printing
│   │   ├── kernel tailscale docker programs stylix
│   │   └── hyprland/             # Hyprland système + greetd/tuigreet + portails
│   └── profiles/
│       ├── base.nix              → tout host
│       └── workstation.nix       → Jade & Cobble : + desktop Hyprland
├── home/
│   ├── features/                 # modules home-manager atomiques (hm.*)
│   │   ├── fish starship tmux neovim nix-aliases fonts obsidian ai-tools
│   │   ├── hyprland/             # config user Hyprland + rofi + mako + hyprlock/hypridle
│   │   └── waybar/               # barre de statut
│   └── profiles/
│       ├── base.nix              → tout host
│       └── desktop.nix           → Jade & Cobble : + Hyprland + Waybar
└── hosts/
    ├── jade/
    └── cobble/

wallpapers/                       # wallpapers (hyprpaper)
```

### Logique profiles / features

Un **feature** est un module atomique avec une option `enable` :

```nix
sys.hyprland.enable = true;   # system feature
hm.waybar.enable    = true;   # home feature
```

Un **profil** compose des features. Pour une nouvelle machine, on importe `profileWorkstation`
et on ajuste ce qui diffère.

---

## Commandes rapides (fish)

### Rebuild

| Commande | Action |
|----------|--------|
| `nrs` | `nixos-rebuild switch` — applique et persiste |
| `nrt` | `nixos-rebuild test` — applique, revert au reboot |
| `nrb` | `nixos-rebuild build` — compile sans appliquer |
| `nrd` | `nixos-rebuild dry-activate` — montre ce qui changerait |
| `nrbo` | `nixos-rebuild boot` — applique au prochain boot |
| `nrvm` | `nixos-rebuild build-vm` — construit une VM QEMU |

### Fonctions

| Commande | Action |
|----------|--------|
| `nrsh jade` / `nrsh cobble` | rebuild switch pour un host précis |
| `nrdeploy cobble 100.x.y.z` | rebuild et déploie en SSH sur un host distant |
| `nrvm-run jade` | build + lance la VM de test d'un host |
| `npkg ripgrep` | cherche un paquet dans nixpkgs |
| `nwhy firefox` | pourquoi ce paquet est dans le store |

### Flake

| Commande | Action |
|----------|--------|
| `nfu` | `nix flake update` |
| `nfc` | `nix flake check` |
| `nfl` | `nix flake lock` |
| `nfs` | `nix flake show` |

### Divers

| Commande | Action |
|----------|--------|
| `ngc` | garbage collect toutes les générations |
| `ngo` | optimise le store (déduplication) |
| `nsh python311` | shell éphémère avec un paquet |
| `nrun cowsay` | exécute un paquet sans l'installer |

---

## Tester avant de déployer

```bash
nix flake check                                                   # évalue tout le flake
nix eval .#nixosConfigurations.jade.config.system.build.toplevel  # éval pure, rapide
nixos-rebuild build --flake .#jade                                # build sans appliquer
sudo nixos-rebuild test --flake .#jade                            # applique temporairement
nixos-rebuild build-vm --flake .#jade && ./result/bin/run-jade-vm # VM QEMU isolée
```

Ces cibles existent aussi dans le `Makefile` (`make check`, `make build-jade`, `make vm-jade`, …).

---

## Ajouter une machine

1. Crée `modules/hosts/<nom>/` avec `default.nix`, `config.nix`, `hardware-configuration.nix`, `disko.nix`.
2. Sur la machine réelle : `sudo nixos-generate-config` puis colle le résultat dans `hardware-configuration.nix`.
3. `sudo nixos-rebuild switch --flake .#<nom>`

## Ajouter un feature

- **Système** : `modules/system/features/<nom>/default.nix` expose `sys.<nom>.enable`, importé dans un profil.
- **Home** : `modules/home/features/<nom>/default.nix` expose `hm.<nom>.enable`, importé dans un profil home.

---

## Bureau Hyprland

- Compositeur **Hyprland** (paquet nixpkgs, compatible avec les plugins `hyprlandPlugins`).
- Barre **Waybar**, launcher **rofi**, notifications **mako**, verrouillage **hyprlock**, veille **hypridle**.
- Thème **Everforest** unifié par **Stylix** (palette dans `modules/lib/palette.nix`).
- Raccourcis principaux : `SUPER+Return` (kitty), `SUPER+Space` (launcher), `SUPER+1..9` (workspaces),
  `SUPER+flèches` (focus), `SUPER+Escape` (lock), `Print` (capture région).

## Changer le mot de passe

```bash
mkpasswd -m sha-512   # copie le hash dans hosts/<host>/config.nix (initialHashedPassword)
sudo nixos-rebuild switch --flake .#<host>
```

---

## Doc Claude Code

Un guide pour exploiter l'agent Claude Code sur ce repo (boucles, subagents, workflows, skills,
mémoire) : [docs/claude-code.md](./docs/claude-code.md). Des skills NixOS custom vivent dans
[`.claude/skills/`](./.claude/skills/).
