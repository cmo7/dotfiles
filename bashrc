# ───────────────────────────────────────────────────────────────
# DETECCIÓN DE SISTEMA OPERATIVO
# ───────────────────────────────────────────────────────────────

OS="$(uname -s)"
case "$OS" in
  Linux*)   export OS_TYPE="linux" ;;
  Darwin*)  export OS_TYPE="mac" ;;
  CYGWIN*|MINGW*|MSYS*) export OS_TYPE="windows" ;;
  *)        export OS_TYPE="unknown" ;;
esac

#Scoop
if [[ "$OS_TYPE" == "windows" ]]; then
  export SCOOP_HOME="$HOME/scoop"
  export PATH="$SCOOP_HOME/shims:$SCOOP_HOME/apps/scoop/current/bin:$PATH"
fi

# Detección de WSL (Linux sobre Windows)
if grep -qi microsoft /proc/version 2>/dev/null; then
  export IS_WSL=true
else
  export IS_WSL=false
fi

# ───────────────────────────────────────────────────────────────
# PATH
# ───────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ───────────────────────────────────────────────────────────────
# JAVA
# ───────────────────────────────────────────────────────────────
# Asignar JAVA_HOME dinámicamente si zulu8-jdk está instalado
if [[ -d "$SCOOP_DIR/apps/zulu8-jdk/current" ]]; then
  export JAVA_HOME=$(scoop_path zulu8-jdk)
fi

alias reload='source ~/.bashrc && echo "🔁 Recargado!"'

# ───────────────────────────────────────────────────────────────
# tmux (solo Linux/macOS/WSL)
# ───────────────────────────────────────────────────────────────

# Detectamos si estamos en Windows puro
if [[ "$OS_TYPE" != "windows" || "$IS_WSL" == "true" ]]; then

  if command -v tmux >/dev/null 2>&1; then
    export TMUX_AUTOSTART=true  # puedes poner a false si no quieres autoinicio

    # Alias útiles
    alias tl='tmux ls'
    alias treload='tmux source-file ~/.tmux.conf && echo "🔁 tmux recargado"'

    tn() {
      local name="${1:-dev}"
      tmux new -s "$name"
    }

    ta() {
      tmux attach -t "${1:-main}"
    }

    tk() {
      tmux kill-session -t "$1"
    }

    # Autoinicio solo si no estamos ya dentro de tmux
    if [[ -z "$TMUX" && "$TMUX_AUTOSTART" == "true" ]]; then
      if tmux has-session -t main 2>/dev/null; then
        tmux attach -t main
      else
        tmux new-session -s main
      fi
    fi
  fi
fi



# ───────────────────────────────────────────────────────────────
# ALIASES (solo si las herramientas están disponibles)
# ───────────────────────────────────────────────────────────────

# ls → exa con iconos si exa está presente
if command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons'
  alias ll='exa -la --icons'
else
  alias ls='ls --color=auto'
  alias ll='ls -la --color=auto'
fi

# bat
if command -v bat >/dev/null 2>&1; then
  export FORCE_COLOR=true
  export BAT_THEME="Dracula"
  alias cat='bat'
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

# Git
alias gs='git status'
alias gc='git commit'


# rg (ripgrep)
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'                               # reemplaza grep
  alias rgg='rg --glob "!.git/*"'               # ignora .git por defecto
  alias rgf='rg --files | fzf'                  # fuzzy find entre archivos
  alias rgh='rg --heading --line-number'        # con encabezados y líneas
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc" # puedes definir configuración global
fi

# ───────────────────────────────────────────────────────────────
# fd - "find" moderno
# ───────────────────────────────────────────────────────────────
if command -v fd >/dev/null 2>&1; then
  alias find='fd'                               # opcional: reemplaza find
  alias ff='fd --type f'                        # buscar archivos
  alias ffd='fd --type d'                       # buscar directorios
  alias fzf-fd='fd --hidden --follow --exclude .git | fzf'  # integración con fzf

  export FD_OPTIONS="--hidden --follow --exclude .git"
fi

# ───────────────────────────────────────────────────────────────
# Zoxide (cd inteligente)
# ───────────────────────────────────────────────────────────────
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'        # reemplaza cd por z
  alias j='z'         # alias tipo autojump
  alias zi='zi'       # uso interactivo con fzf (si está instalado)
fi

# ───────────────────────────────────────────────────────────────
# PROMPT
# ───────────────────────────────────────────────────────────────
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# ───────────────────────────────────────────────────────────────
# UTILIDADES ADICIONALES
# ───────────────────────────────────────────────────────────────

# Buscar en el historial
hgrep() {
  history | grep --color=always "$@"
}

# Obtener la ruta de un programa instalado con Scoop
scoop_path() {
  local app="$1"
  echo "${SCOOP:-$HOME/scoop}/apps/$app/current"
}

fedit() {
  fd --hidden --follow --exclude .git . "${1:-.}" | fzf | xargs -r "${EDITOR:-nvim}"
}

search() {
  RG_PREFIX="rg --column --line-number --no-heading --color=always"
  FZF_DEFAULT_COMMAND="$RG_PREFIX ''" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --preview 'bat --style=numbers --color=always --line-range :500 {1}' \
        --delimiter : \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
}

update() {
  if command -v scoop >/dev/null 2>&1; then
    echo "🔄 Usando scoop (Windows)"
    scoop update "*"

  elif command -v dnf >/dev/null 2>&1; then
    echo "🔄 Usando dnf (Fedora)"
    sudo dnf upgrade --refresh -y

  elif command -v apt >/dev/null 2>&1; then
    echo "🔄 Usando apt (Debian/Ubuntu)"
    sudo apt update && sudo apt upgrade -y

  elif command -v pacman >/dev/null 2>&1; then
    echo "🔄 Usando pacman (Arch)"
    sudo pacman -Syu

  elif command -v zypper >/dev/null 2>&1; then
    echo "🔄 Usando zypper (openSUSE)"
    sudo zypper refresh && sudo zypper update -y

  elif command -v brew >/dev/null 2>&1; then
    echo "🔄 Usando Homebrew (macOS)"
    brew update && brew upgrade

  else
    echo "❌ No se detectó ningún gestor de paquetes compatible."
    return 1
  fi
}

# Lista base de herramientas
TOOLS_BASE=(git fzf fd rg bat exa starship zoxide)

# 🩺 Comprobación de herramientas instaladas
doctor() {
  echo "🩺 Comprobando herramientas..."

  for tool in "${TOOLS_BASE[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf "✅ %-10s está instalado\n" "$tool"
    else
      printf "❌ %-10s NO está instalado\n" "$tool"
    fi
  done
}

# 💊 Instalación condicional de herramientas según sistema
installdeps() {
  echo "💊 Instalando dependencias..."

  local to_install=()
  for tool in "${TOOLS_BASE[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      to_install+=("$tool")
    fi
  done

  if [ "${#to_install[@]}" -eq 0 ]; then
    echo "🎉 Todo está instalado. No hay nada que hacer."
    return 0
  fi

  echo "📦 Faltan: ${to_install[*]}"

  if command -v scoop >/dev/null 2>&1; then
    echo "🪟 Usando scoop (Windows)"
    scoop install "${to_install[@]}"

  elif command -v dnf >/dev/null 2>&1; then
    echo "🐧 Usando dnf (Fedora)"
    sudo dnf install -y "${to_install[@]}"

  elif command -v apt >/dev/null 2>&1; then
    echo "🐧 Usando apt (Debian/Ubuntu)"
    sudo apt update
    sudo apt install -y "${to_install[@]}"

  elif command -v pacman >/dev/null 2>&1; then
    echo "🐧 Usando pacman (Arch)"
    sudo pacman -S --noconfirm "${to_install[@]}"

  elif command -v brew >/dev/null 2>&1; then
    echo "🍎 Usando Homebrew (macOS)"
    brew install "${to_install[@]}"

  else
    echo "❌ No se detectó ningún gestor de paquetes compatible."
    return 1
  fi
}