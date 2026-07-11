#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/home"

command -v stow >/dev/null 2>&1 || sudo apt-get install -y stow

while IFS= read -r -d '' f; do
  rel="${f#"$PKG_DIR"/}"
  target="$HOME/$rel"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "  backup : $target -> $target.bak"
    mv "$target" "$target.bak"
  fi
done < <(find "$PKG_DIR" -type f -print0)

stow --no-folding --dir="$SCRIPT_DIR" --target="$HOME" home

echo
echo "✅ Dotfiles liés depuis $PKG_DIR vers $HOME"
echo "   Vérifie :  ls -l ~/.config/fish/config.fish"
