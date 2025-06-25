#!/usr/bin/env bash

set -e

# Ruta base del repositorio de dotfiles
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
FILES=("bashrc" "tmux.conf" "gitconfig")

# Detectar entorno
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
IS_WINDOWS=false
if [[ "$OS" == "mingw"* || "$OS" == "msys"* || "$OS" == "cygwin"* ]]; then
  IS_WINDOWS=true
fi

echo "🛠️  Instalando dotfiles desde $DOTFILES_DIR"
echo "🌐 Sistema detectado: $OS"

link_or_copy() {
  src="$1"
  dest="$2"

  # Si el destino ya existe y no es symlink, hacer backup
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.bak"
    echo "📦 Backup creado: $dest.bak"
  fi

  # Intentar symlink, fallback a copia si falla
  if ln -sf "$src" "$dest" 2>/dev/null; then
    echo "🔗 Enlace: $dest → $src"
  else
    cp "$src" "$dest"
    echo "📋 Copia:  $dest ← $src (sin symlink)"
  fi
}

for file in "${FILES[@]}"; do
  src="$DOTFILES_DIR/$file"
  dest="$HOME/.$file"

  if [[ -f "$src" ]]; then
    link_or_copy "$src" "$dest"
  else
    echo "⚠️  Archivo no encontrado: $src — omitido"
  fi
done

# Starship config
STARSHIP_SRC="$DOTFILES_DIR/config/starship.toml"
STARSHIP_DEST="$HOME/.config/starship.toml"

mkdir -p "$(dirname "$STARSHIP_DEST")"

if [[ -f "$STARSHIP_SRC" ]]; then
  link_or_copy "$STARSHIP_SRC" "$STARSHIP_DEST"
else
  echo "⚠️  Config starship no encontrada: $STARSHIP_SRC"
fi

echo "✅ Dotfiles instalados."

