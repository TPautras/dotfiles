# Granite — serveur (Ubuntu Server 24.04 LTS)

```
granite/
├── 00-bootstrap.sh   # apt: base, Tailscale, driver NVIDIA, Docker, NVIDIA toolkit, UFW
├── 20-shell.sh       # fish, starship, tmux+tpm, neovim+LazyVim, eza/bat/rg/fd/zoxide/atuin…
├── 25-dotfiles.sh    # symlink (GNU Stow) de home/ vers ~
├── 10-coolify.sh     # install Coolify
├── home/             # dotfiles serveur (source de vérité, symlinkés dans ~)
│   └── .config/      # fish, starship.toml, tmux, nvim (LazyVim, thème Everforest)
└── hermes/
    ├── Dockerfile        # image Hermes (pip install hermes-agent)
    ├── docker-compose.yml
    └── .env.example      # secrets (le vrai .env est gitignored)
```

---

## Stack

```
Ubuntu Server 24.04 LTS (headless)
├── SSH (clés)                          accès de base
├── Tailscale                           accès privé depuis tes laptops, sans port public
├── Docker Engine + Compose             runtime des containers
├── NVIDIA driver + Container Toolkit   GPU dans les containers
├── Coolify                             PaaS auto-hébergé (gère ses containers)
└── Hermes                              agent containerisé (./hermes)
```

---

## Installation pas à pas

### 1. Installer Ubuntu Server 24.04 LTS

- Télécharge l'ISO : <https://ubuntu.com/download/server>
- Flash sur clé USB (Rufus / balenaEtcher / `dd`), boote Granite dessus.
- Pendant l'install : crée l'utilisateur **`thomas`**, coche **"Install OpenSSH
  server"**, et ajoute ta clé publique SSH si proposé.

### 2. Première connexion + récupérer ce dossier

```bash
ssh thomas@<IP_LAN_DE_GRANITE>

# Récupère uniquement les scripts de déploiement (ou clone tout le repo)
git clone <URL_DE_TON_REPO> dotfiles
cd dotfiles/granite
```

### 3. Bootstrap (Docker, GPU, Tailscale, pare-feu)

```bash
chmod +x *.sh
sudo ./00-bootstrap.sh
```

Puis :

```bash
# Rejoindre ton réseau Tailscale (ouvre un lien d'auth)
sudo tailscale up

# Reconnecte-toi pour activer le groupe docker (ou : newgrp docker)
exit && ssh thomas@granite

# (si GPU) vérifier l'accès GPU depuis un container
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu24.04 nvidia-smi
```

### 4. Shell & dotfiles (même confort que les laptops)

```bash
cd ~/dotfiles/granite
./20-shell.sh        # ⚠️ PAS en sudo — installe fish, starship, tmux, nvim, eza, bat…
./25-dotfiles.sh     # symlinke home/ → ~ (fish, starship.toml, tmux.conf, nvim)
```

Puis :

```bash
exit && ssh thomas@granite          # nouvelle session → démarre sous fish
# tmux : prefix Ctrl-a puis 'I' pour installer les plugins (tpm)
# nvim : au 1er lancement, LazyVim installe plugins + LSP (Mason) tout seul
```

> **Dotfiles = source unique de vérité.** Les fichiers de `granite/home/` sont
> *symlinkés* dans `~` (pas copiés). Tu édites dans le repo, `git pull` sur
> Granite, et c'est appliqué. Voir [Gérer ses dotfiles](#gérer-ses-dotfiles).

### 5. Coolify

```bash
cd ~/dotfiles/granite
sudo ./10-coolify.sh
```

Ouvre l'UI : `http://granite:8000` (via Tailscale) ou `http://<IP_LAN>:8000`,
crée ton compte admin. Pour exposer une app sur un domaine : Coolify →
Settings → Domain (Let's Encrypt auto via Traefik).

### 6. Hermes

```bash
cd ~/dotfiles/granite/hermes
cp .env.example .env
nano .env                 # colle DISCORD_TOKEN + ANTHROPIC_API_KEY
docker compose up -d --build
docker compose logs -f
```

> ⚠️ Les anciennes clés étaient chiffrées avec sops dans l'ancienne config
> NixOS (supprimée). Tu dois re-renseigner **DISCORD_TOKEN** et
> **ANTHROPIC_API_KEY** dans `hermes/.env`.
>
> La commande de lancement de Hermes dépend de sa version : vérifie avec
> `docker compose run --rm hermes hermes --help`, puis décommente/ajuste
> `command:` dans `docker-compose.yml` (ex. mode gateway pour Discord).
>
> Alternative : déployer `hermes/` comme **application Coolify** (source = repo,
> build = Dockerfile, variables d'env dans l'UI) plutôt qu'en compose manuel.

---

## Remote dev

Depuis ta tour gaming (Windows) ou ton laptop de travail :

1. **Tailscale** sur le client → Granite est joignable en `granite` partout.
2. **VS Code + extension Remote-SSH** → `Connect to Host… → thomas@granite`.
   VS Code installe son serveur tout seul, tu édites comme en local. Rien à
   préinstaller côté Granite à part SSH.

`~/.ssh/config` pratique :

```sshconfig
Host granite
    HostName granite          # nom Tailscale (ou IP LAN)
    User thomas
```

---

## Gérer ses dotfiles

**Un seul repo, pas de `.config` séparé.** Les configs serveur vivent dans
`granite/home/` et sont **symlinkées** dans `~` par `25-dotfiles.sh` (GNU Stow).

```
granite/home/.config/fish/config.fish   ──symlink──>   ~/.config/fish/config.fish
granite/home/.config/starship.toml      ──symlink──>   ~/.config/starship.toml
granite/home/.config/tmux/tmux.conf     ──symlink──>   ~/.config/tmux/tmux.conf
granite/home/.config/nvim/…             ──symlink──>   ~/.config/nvim/…
```

Workflow : tu édites dans le repo (depuis ton laptop ou via Remote-SSH), tu
`git push`, puis sur Granite `git pull`. Comme ce sont des liens, c'est
appliqué sans recopier. Ajouter un fichier = le poser sous `granite/home/`
(en miroir de `~`) puis relancer `./25-dotfiles.sh`.

### Pourquoi Stow plutôt qu'autre chose ?

| Option | Verdict |
|---|---|
| **GNU Stow** (choisi) | 1 paquet apt, symlinks déclaratifs depuis un dossier en miroir de `~`. Simple, réversible (`stow -D home`), zéro magie. ✅ |
| Bare git repo (`--git-dir=$HOME`) | Pas de symlinks, mais `$HOME` devient un repo entier → fragile, facile de committer n'importe quoi. ❌ pour un débutant. |
| chezmoi / yadm | Puissants (templating, secrets, multi-OS) mais ré-introduisent une couche d'outil à apprendre — l'inverse de ce qu'on cherche ici. Surdimensionné. |
| Copier les fichiers | Pas de source de vérité : tu édites une copie, le repo diverge. ❌ |

### Note : laptops (NixOS) vs serveur (Stow)

Les laptops génèrent leurs configs via **home-manager** (DSL Nix → fichiers).
Le serveur utilise des **fichiers bruts** symlinkés. Les deux vivent dans le
même repo mais sous des formes différentes (Nix vs fichier). C'est volontaire et
sans accroc tant que les deux restent ici.

> **Évolution possible (DRY)** : extraire les configs réellement identiques
> (`starship.toml`, `tmux.conf`, lua nvim) dans un dossier `shared/`, que
> home-manager référence via `xdg.configFile.<x>.source = ../shared/…` et que le
> serveur symlinke. Une seule source pour les deux. Plus élégant, mais c'est un
> refactor de la config laptop — à faire plus tard si l'envie vient.

---

## Réinstaller from scratch

1. Réinstalle Ubuntu Server 24.04.
2. `git clone` puis :
   ```bash
   cd dotfiles/granite && chmod +x *.sh
   sudo ./00-bootstrap.sh && sudo tailscale up
   ./20-shell.sh && ./25-dotfiles.sh
   sudo ./10-coolify.sh
   ```
3. Restaure tes apps Coolify (Coolify peut sauvegarder/restaurer sa config).
4. `docker compose up -d --build` dans `hermes/` après avoir remis `.env`.

→ ~30 min, sans toucher aux laptops NixOS.
