# modules/hosts — les machines

Un dossier par machine. L'idée est qu'un host ne contienne **que ce qui lui est propre** :
hostname, matériel, et les quelques features spécifiques. Tout le reste vient des profils.

```
<host>/
├── default.nix                 assemble le nixosSystem
├── config.nix                  hostname + spécificités
├── hardware-configuration.nix  généré par nixos-generate-config
└── disko.nix                   partitionnement (seulement si géré par disko)
```

Un `config.nix` typique tient en 6 lignes. S'il grossit, c'est probablement qu'un
morceau devrait remonter dans un profil ou une feature.

## Les machines

| Host | Profil | Particularités |
|------|--------|----------------|
| jade | `profileLaptop` | laptop AMD de test |
| cobble | `profileLaptop` | laptop de travail |
| heimdall | `profileTower` | tour, GPU AMD, `sys.gaming.enable` + disko |

jade et cobble ont été installés à la main, ils n'ont pas de `disko.nix`.

## Ajouter une machine

1. Copier le dossier d'un host existant, renommer les attributs
   (`flake.nixosModules.<host>Hardware`, etc.).
2. Choisir le profil : `profileLaptop` ou `profileTower`.
3. Sur la machine, générer le vrai hardware config :
   ```bash
   sudo nixos-generate-config --show-hardware-config
   ```
   et coller le résultat (garder l'enrobage `flake.nixosModules.<host>Hardware`).
   Si la machine utilise disko, ajouter `--no-filesystems` : c'est disko qui fournit
   les `fileSystems`.
4. `sudo nixos-rebuild switch --flake .#<host>`

**Nouveaux fichiers = `git add` obligatoire.** Un flake ne voit que ce qui est suivi
par git ; un fichier non tracké donne une erreur d'évaluation qui ne dit pas son nom.

## disko

`disko.nix` **efface intégralement** le disque listé dans `device`. Avant de le lancer :

```bash
lsblk    # vérifier que c'est le bon disque
```

Sur heimdall, Windows est sur un autre disque physique — c'est ce qui rend l'opération
sûre. Si un jour les deux OS partagent un disque, il ne faut pas utiliser disko du tout.

Installation avec disko :

```bash
sudo nix run github:nix-community/disko -- --mode destroy,format,mount --flake .#heimdall
sudo nixos-install --flake .#heimdall
```
