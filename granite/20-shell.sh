#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
  echo "✋ Ne lance pas ce script en root/sudo. Fais : ./20-shell.sh" >&2
  exit 1
fi

ARCH="$(dpkg --print-architecture)"
export DEBIAN_FRONTEND=noninteractive

echo "==> 1/9  Paquets APT (trousse CLI de base)"
sudo apt-get update
sudo apt-get install -y \
  fish tmux git curl wget unzip zip p7zip-full ca-certificates gnupg \
  build-essential gcc cmake make pkg-config \
  python3 python3-pip python3-venv pipx \
  ripgrep fd-find bat fzf htop jq duf entr zoxide cbonsai

sudo ln -sf "$(command -v batcat)"  /usr/local/bin/bat 2>/dev/null || true
sudo ln -sf "$(command -v fdfind)"  /usr/local/bin/fd  2>/dev/null || true

echo "==> 2/9  eza (dépôt officiel gierens)"
if ! command -v eza >/dev/null 2>&1; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y eza
fi

echo "==> 3/9  Node.js LTS (pour Neovim/LazyVim + outils)"
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

echo "==> 4/9  Starship (prompt)"
if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | sudo sh -s -- -y
fi

echo "==> 5/9  Atuin (historique shell)"
if ! command -v atuin >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

echo "==> 6/9  Neovim (dernière version stable, tarball officiel)"
if ! command -v nvim >/dev/null 2>&1; then
  tmp="$(mktemp -d)"
  curl -fL -o "$tmp/nvim.tar.gz" \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm -rf "$tmp"
fi

echo "==> 7/9  lazygit"
if ! command -v lazygit >/dev/null 2>&1; then
  ver="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -1)"
  tmp="$(mktemp -d)"
  curl -fL -o "$tmp/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${ver}_Linux_x86_64.tar.gz"
  tar -C "$tmp" -xzf "$tmp/lazygit.tar.gz" lazygit
  sudo install "$tmp/lazygit" /usr/local/bin
  rm -rf "$tmp"
fi

echo "==> 8/9  Outils best-effort (procs, dust, smassh, tealdeer, pokemon)"
if ! command -v procs >/dev/null 2>&1 || ! command -v dust >/dev/null 2>&1; then
  sudo apt-get install -y cargo || true
  command -v cargo >/dev/null 2>&1 && cargo install procs du-dust || \
    echo "    (procs/dust ignorés — cargo indisponible)"
fi
command -v tldr >/dev/null 2>&1 || { sudo apt-get install -y tealdeer 2>/dev/null || cargo install tealdeer 2>/dev/null || true; }
command -v smassh >/dev/null 2>&1 || pipx install smassh || true
if ! command -v pokemon-colorscripts >/dev/null 2>&1; then
  tmp="$(mktemp -d)"
  if git clone --depth 1 https://gitlab.com/phoneybadger/pokemon-colorscripts.git "$tmp/pcs"; then
    ( cd "$tmp/pcs" && sudo ./install.sh ) || true
  fi
  rm -rf "$tmp"
fi
mkdir -p "$HOME/.local/bin"

echo "==> 9/9  tmux plugin manager (tpm) + fish par défaut"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
FISH_BIN="$(command -v fish)"
grep -qxF "$FISH_BIN" /etc/shells || echo "$FISH_BIN" | sudo tee -a /etc/shells > /dev/null
sudo chsh -s "$FISH_BIN" "$USER"

echo
echo "✅ Shell installé."
echo "   • Lance  ./25-dotfiles.sh  pour symlinker les configs (fish, starship, tmux, nvim)."
echo "   • Ouvre une NOUVELLE session SSH pour démarrer sous fish."
echo "   • Dans tmux : prefix (Ctrl-a) puis 'I' pour installer les plugins (tpm)."
echo "   • Au 1er lancement de nvim : LazyVim installe ses plugins + LSP (Mason) tout seul."
