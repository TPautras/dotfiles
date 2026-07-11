---
name: nix-update
description: Met à jour les inputs du flake NixOS puis vérifie que la config tient toujours. À utiliser quand l'utilisateur veut mettre à jour ses paquets, bumper nixpkgs/hyprland, ou rafraîchir le flake.lock.
---

# nix-update

Étapes :

1. Note la révision courante : `git log --oneline -1 flake.lock` (pour pouvoir revert).
2. Mets à jour tous les inputs : `nix flake update`. Pour un input précis seulement :
   `nix flake update <input>` (ex. `nix flake update hyprland`).
3. Vérifie que rien n'est cassé : `nix flake check`, puis `nixos-rebuild build --flake .#jade`.
4. Montre un diff lisible des inputs modifiés (compare `flake.lock` avant/après, ou `git diff flake.lock`).
5. Si le build casse à cause d'une mise à jour, propose de revert `flake.lock`
   (`git checkout flake.lock`) ou d'épingler l'input fautif.

Ne commit pas automatiquement : laisse l'utilisateur décider une fois le build vert.
