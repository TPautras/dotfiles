---
name: nix-rebuild
description: Rebuild NixOS d'un host de ce repo (jade ou cobble) en mode build, test ou switch, avec un nix flake check préalable. À utiliser quand l'utilisateur demande de rebuild, appliquer, ou tester la config d'une machine.
---

# nix-rebuild

Arguments attendus : le host (ex. `jade`, `cobble`) et le mode (`build` par défaut, sinon `test`
ou `switch`). Si l'utilisateur ne précise pas, demande le host et propose `build` par défaut.

Étapes :

1. `nix flake check` d'abord. Si ça échoue, arrête-toi et rapporte l'erreur — ne rebuild pas une
   config cassée.
2. Selon le mode :
   - `build` : `nixos-rebuild build --flake .#<host>` (ne touche rien, sûr).
   - `test` : `sudo nixos-rebuild test --flake .#<host>` (applique, revert au reboot).
   - `switch` : `sudo nixos-rebuild switch --flake .#<host>` (applique et persiste).
3. `switch`/`test` ne sont pertinents que sur la machine correspondante. Si le hostname courant ne
   correspond pas au host demandé, préviens l'utilisateur (build reste possible partout).
4. Rapporte le résultat : succès, ou la première erreur de compilation avec le fichier concerné.

Rappel : Hyprland vient de nixpkgs (cache.nixos.org), tout comme ses plugins
(`pkgs.hyprlandPlugins.*`) — garder les deux depuis nixpkgs évite les incompatibilités d'API.
