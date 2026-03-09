hgrep() {
  history | grep --color=always "$@"
}

fedit() {
  command -v fd >/dev/null 2>&1 || { echo "❌ fd no está instalado."; return 1; }
  command -v fzf >/dev/null 2>&1 || { echo "❌ fzf no está instalado."; return 1; }
  [[ -n "${EDITOR:-}" ]] || { echo "❌ \$EDITOR no está definido."; return 1; }
  fd --hidden --follow --exclude .git . "${1:-.}" | fzf | xargs -r "$EDITOR"
}

search() {
  command -v rg >/dev/null 2>&1 || { echo "❌ ripgrep (rg) no está instalado."; return 1; }
  command -v fzf >/dev/null 2>&1 || { echo "❌ fzf no está instalado."; return 1; }
  command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1 || { echo "❌ bat no está instalado."; return 1; }
  RG_PREFIX="rg --column --line-number --no-heading --color=always"
  FZF_DEFAULT_COMMAND="$RG_PREFIX ''" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --preview 'bat --style=numbers --color=always --line-range :500 {1}' \
        --delimiter : \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
}

conn() {
  # ========= Verificar dependencias =========
  local REQUIRED_CMDS=("fzf" "awk" "sort" "ssh")
  for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "❌ El comando requerido '$cmd' no está disponible. Por favor, instálalo antes de continuar."
      return 1
    fi
  done

  # ========= Configuración =========
  local SSH_CONFIG="$HOME/.ssh/config"
  [[ ! -f "$SSH_CONFIG" ]] && {
    echo "❌ No se encontró $SSH_CONFIG"
    return 1
  }

  # ========= Extraer hosts =========
  local hosts
  hosts=$(awk '/^Host / {sub(/#.*/, ""); for (i=2; i<=NF; i++) print $i}' "$SSH_CONFIG" | sort -u)

  # ========= Selección con fzf =========
  local selected
  selected=$(echo "$hosts" | fzf --prompt="Selecciona un host: " --height=40% --border --exit-0)

  if [[ -n "$selected" ]]; then
    echo "🚀 Conectando a $selected..."
    ssh "$selected"
  else
    echo "❎ No se seleccionó ningún host."
  fi
}


extract() {
  local file="$1"
  [[ ! -f "$file" ]] && {
    echo "❌ '$file' no es un archivo válido."
    return 1
  }

  local use_pv
  if command -v pv >/dev/null 2>&1; then
    use_pv=true
  else
    use_pv=false
  fi

  echo "📦 Procesando archivo: $file"

  case "$file" in
    *.tar.gz|*.tgz)
      echo "🔧 Extrayendo archivo .tar.gz..."
      if $use_pv; then
        pv "$file" | tar xzv -f -
      else
        tar xzvf "$file"
      fi
      ;;
    *.tar.bz2|*.tbz2)
      echo "🔧 Extrayendo archivo .tar.bz2..."
      if $use_pv; then
        pv "$file" | tar xjv -f -
      else
        tar xjvf "$file"
      fi
      ;;
    *.tar.xz)
      echo "🔧 Extrayendo archivo .tar.xz..."
      if $use_pv; then
        pv "$file" | tar xJv -f -
      else
        tar xJvf "$file"
      fi
      ;;
    *.tar)
      echo "🔧 Extrayendo archivo .tar..."
      tar xvf "$file"
      ;;
    *.zip)
      echo "🔧 Extrayendo archivo .zip..."
      unzip -o "$file"
      ;;
    *.rar)
      echo "🔧 Extrayendo archivo .rar..."
      unrar x "$file"
      ;;
    *.gz)
      echo "🔧 Descomprimiendo archivo .gz..."
      gunzip -v "$file"
      ;;
    *.bz2)
      echo "🔧 Descomprimiendo archivo .bz2..."
      bunzip2 -v "$file"
      ;;
    *.7z)
      echo "🔧 Extrayendo archivo .7z..."
      7z x "$file"
      ;;
    *)
      echo "❌ No sé cómo extraer '$file'"
      return 1
      ;;
  esac

  echo "✅ Extracción completada."
}


# Alias para extract
alias x='extract'

# Función para editar con editor visual (mejor para archivos de configuración grandes)
vedit() {
  command -v fd >/dev/null 2>&1 || { echo "❌ fd no está instalado."; return 1; }
  command -v fzf >/dev/null 2>&1 || { echo "❌ fzf no está instalado."; return 1; }
  [[ -n "${VISUAL:-}" ]] || { echo "❌ \$VISUAL no está definido."; return 1; }
  if [[ $# -eq 0 ]]; then
    # Si no se proporciona archivo, usar fzf para seleccionar
    local file
    file=$(fd --hidden --follow --exclude .git --type f . "${PWD}" | fzf --prompt="📝 Editar con $VISUAL: " --height=40% --border --preview="bat --color=always {}")
    [[ -n "$file" ]] && "$VISUAL" "$file"
  else
    # Si se proporciona archivo, editarlo directamente
    "$VISUAL" "$@"
  fi
}