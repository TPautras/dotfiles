# nvim — config Neovim

Config LazyVim en lua, **volontairement hors du store Nix**.

`~/.config/nvim` est un lien vers ce dossier (`mkOutOfStoreSymlink`, voir
`modules/home/features/neovim/`). Donc : tu édites un fichier ici, tu relances nvim,
c'est pris en compte. Pas de rebuild home-manager.

## Qui gère quoi

- **Nix** installe le binaire nvim, les serveurs LSP, les formatters, les compilateurs.
  C'est là que la reproductibilité compte : même pyright sur les trois machines.
- **lazy.nvim** gère les plugins, pinnés dans `lazy-lock.json`. Ce fichier doit être
  committé — c'est lui qui rend la config reproductible.

`checker` est désactivé dans `init.lua` : sinon lazy met les plugins à jour tout seul
et le lockfile ne veut plus rien dire. Pour mettre à jour volontairement : `:Lazy update`,
puis committer le lockfile.

## Mason est désactivé

Mason télécharge des binaires précompilés dynamiquement liés, qui ne tournent pas sur
NixOS. Il est donc coupé dans `lua/plugins/lsp.lua`, et les serveurs LSP viennent de
`extraPackages` côté Nix.

Conséquence : **pour ajouter un langage, il faut deux choses** — l'extra LazyVim dans
`init.lua`, et le serveur LSP dans `modules/home/features/neovim/default.nix`.

## Fichiers

```
init.lua                    bootstrap lazy + liste des extras LazyVim
lua/plugins/colorscheme.lua Everforest
lua/plugins/lsp.lua         serveurs LSP + désactivation de Mason
```
