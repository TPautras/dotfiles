# modules/home — config utilisateur (home-manager)

Même logique que `system/`, mais côté user : dotfiles, apps, bureau. Les options sont
préfixées `hm.` au lieu de `sys.`.

Ces modules ne sont **pas** importés directement par les hosts. Ils passent par
`sys.user.homeModules`, alimenté par les profils système (voir `../system/README.md`).

## features/

Un dossier = un bloc avec un `enable`. Rien de spécial à savoir, sauf pour les cas
suivants.

### hypr/

Tout ce qui touche à Hyprland est regroupé là, avec un sous-dossier par brique :
`hyprland/`, `plugins/`, `hyprlock/`, `hypridle/`, `wallpaper/`.

La config Hyprland elle-même est découpée en fichiers préfixés `_` :

```
hyprland/
├── default.nix      assemble le tout
├── _keybinds.nix    tous les binds
├── _appearance.nix  general / decoration / animations
├── _input.nix       clavier, souris, touchpad
└── _shader.nix      le shader CRT rétro
```

Le préfixe `_` n'est pas cosmétique : import-tree ignore tout chemin contenant `/_`,
donc ces fichiers ne sont pas chargés comme des modules flake-parts. Ils sont tirés
explicitement par des `import ./_x.nix` dans `default.nix`. Si tu enlèves le `_`,
l'évaluation casse.

### neovim/

Le module installe nvim, les LSP et les toolchains — mais **pas** la config lua.
Celle-ci vit dans `nvim/` à la racine du repo, liée via `mkOutOfStoreSymlink`.

Concrètement : `~/.config/nvim` pointe vers `~/.dotfiles/nvim`, donc tu édites tes
fichiers lua et tu relances nvim. Pas de rebuild. Les plugins sont gérés par lazy.nvim
et pinnés par `nvim/lazy-lock.json`, qu'il faut committer.

Mason est désactivé exprès (`nvim/lua/plugins/lsp.lua`) : il télécharge des binaires
dynamiquement liés qui ne tournent pas sur NixOS. Les serveurs LSP viennent de
`extraPackages`, côté Nix.

### wallpaper/ et hyprlock/

Le wallpaper actif est suivi par un lien stable `~/.cache/wallpaper/current`.
Le wrapper `lockscreen` (défini dans `hyprlock/`) interroge hyprpaper avant de
verrouiller et met le lien à jour, ce qui fait que l'écran de verrouillage suit le
wallpaper choisi avec walt. `hyprlock`, `wlogout` et `hypridle` appellent tous
`lockscreen`, jamais `hyprlock` directement.

## profiles/

```
homeBase      shell, nvim, tmux, git — tous les hosts
homeDesktop   Hyprland, waybar, rofi, apps graphiques
homeLaptop    juste la veille auto (suspendTimeout)
```
