---
name: nix-check
description: Valide le flake NixOS de ce repo — nix flake check puis évaluation pure des toplevels de chaque host (jade, cobble). À utiliser après toute modification de la config Nix, ou quand l'utilisateur demande de vérifier/checker le flake.
---

# nix-check

Objectif : détecter rapidement les erreurs de la config sans tout builder.

Étapes :

1. Lance `nix flake check` à la racine du repo. Il évalue tous les outputs et attrape les erreurs
   de typage/import.
2. Pour chaque host déclaré dans `modules/hosts/`, évalue le toplevel sans builder :
   ```bash
   nix eval .#nixosConfigurations.jade.config.system.build.toplevel --raw
   nix eval .#nixosConfigurations.cobble.config.system.build.toplevel --raw
   ```
   (Découvre la liste des hosts en listant `modules/hosts/` plutôt que de la coder en dur.)
3. Si une commande échoue, lis le message, identifie le fichier fautif sous `modules/`, corrige,
   et relance uniquement l'étape qui a échoué.
4. Rends un résumé : ce qui passe, ce qui échoue, et la correction appliquée le cas échéant.

Ne lance PAS de `nixos-rebuild switch` ici — cette skill est en lecture/évaluation seulement.
