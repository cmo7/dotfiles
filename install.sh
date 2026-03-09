#!/usr/bin/env bash

set -e

# Ruta base del repositorio de dotfiles
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
FILES=("bashrc" "tmux.conf" "vimrc")
GITCONFIGS=("gitconfig-nartex" "gitconfig-personal")
COPY_MODE=false

# Parsear flags
for arg in "$@"; do
  case "$arg" in
    -c|--copy)
      COPY_MODE=true
      shift
      ;;
  esac
done

# Detectar entorno
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
IS_WINDOWS=false
if [[ "$OS" == "mingw"* || "$OS" == "msys"* || "$OS" == "cygwin"* ]]; then
  IS_WINDOWS=true
fi

echo "🛠️  Instalando dotfiles desde $DOTFILES_DIR"
echo "🌐 Sistema detectado: $OS"
$COPY_MODE && echo "📋 Modo: Copiar archivos" || echo "🔗 Modo: Enlazar archivos"

link_or_copy() {
  local src="$1"
  local dest="$2"

  [[ -e "$dest" && ! -L "$dest" ]] && mv "$dest" "$dest.bak" && echo "📦 Backup creado: $dest.bak"

  if $COPY_MODE; then
    cp "$src" "$dest"
    echo "📋 Copia:  $dest ← $src"
  else
    if ln -sf "$src" "$dest" 2>/dev/null; then
      echo "🔗 Enlace: $dest → $src"
    else
      cp "$src" "$dest"
      echo "⚠️  Fallback a copia por fallo en enlace simbólico"
    fi
  fi
}

copy_and_interpolate() {
  local src="$1"
  local dest="$2"

  [[ -e "$dest" && ! -L "$dest" ]] && mv "$dest" "$dest.bak" && echo "📦 Backup creado: $dest.bak"
  sed "s|\${HOME}|$HOME|g" "$src" > "$dest"
  echo "📋 Copia interpolada: $dest ← $src"
}

# Archivos generales (excepto gitconfig)
for file in "${FILES[@]}"; do
  src="$DOTFILES_DIR/$file"
  dest="$HOME/.$file"
  [[ -f "$src" ]] && link_or_copy "$src" "$dest" || echo "⚠️  Archivo no encontrado: $src — omitido"
done

# Git config principal (con interpolación)
GITCONFIG_SRC="$DOTFILES_DIR/gitconfig"
GITCONFIG_DEST="$HOME/.gitconfig"
[[ -f "$GITCONFIG_SRC" ]] && copy_and_interpolate "$GITCONFIG_SRC" "$GITCONFIG_DEST" || echo "⚠️  .gitconfig no encontrado: $GITCONFIG_SRC"

# Git configs contextuales (siempre copia)
for gconf in "${GITCONFIGS[@]}"; do
  src="$DOTFILES_DIR/git/$gconf"
  dest="$HOME/.${gconf}"
  [[ -f "$src" ]] && cp "$src" "$dest" && echo "📋 Copia de $gconf → $dest" || echo "⚠️  Git config no encontrada: $src — omitida"
done

# ripgrep config
RIPGREP_SRC="$DOTFILES_DIR/ripgreprc"
RIPGREP_DEST="$HOME/.ripgreprc"
[[ -f "$RIPGREP_SRC" ]] && link_or_copy "$RIPGREP_SRC" "$RIPGREP_DEST" || echo "⚠️  ripgreprc no encontrado: $RIPGREP_SRC"

# Starship config
STARSHIP_SRC="$DOTFILES_DIR/config/starship.toml"
STARSHIP_DEST="$HOME/.config/starship.toml"
mkdir -p "$(dirname "$STARSHIP_DEST")"
[[ -f "$STARSHIP_SRC" ]] && link_or_copy "$STARSHIP_SRC" "$STARSHIP_DEST" || echo "⚠️  Config starship no encontrada: $STARSHIP_SRC"

# Neovim config
NVIM_SRC="$DOTFILES_DIR/config/nvim/init.lua"
NVIM_DEST="$HOME/.config/nvim/init.lua"
mkdir -p "$(dirname "$NVIM_DEST")"
[[ -f "$NVIM_SRC" ]] && link_or_copy "$NVIM_SRC" "$NVIM_DEST" || echo "⚠️  Config nvim no encontrada: $NVIM_SRC"

# bashrc.d
ensure_bashrc_d() {
  local dir="$HOME/.bashrc.d"
  mkdir -p "$dir"
  local src_dir="$DOTFILES_DIR/bashrc.d"
  if [[ -d "$src_dir" ]]; then
    for file in "$src_dir"/*.sh; do
      [[ -f "$file" ]] && link_or_copy "$file" "$dir/$(basename "$file")"
    done
  else
    echo "⚠️  No existe $src_dir"
  fi
}
ensure_bashrc_d

# Crear estructura de código base
ensure_dir() {
  [[ -d "$1" ]] && echo "✅ Directorio ya existe: $1" || (mkdir -p "$1" && echo "📁 Directorio creado: $1")
}
ensure_dir "$HOME/code/nartex"
ensure_dir "$HOME/code/personal"

echo "✅ Instalación finalizada."
