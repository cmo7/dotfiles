add_path_front_unique() {
  # Añade el primer argumento al frente de PATH si no está ya presente
  [ -z "$1" ] && return
  case ":$PATH:" in
    *":$1:") ;;
    *) PATH="$1${PATH:+":$PATH"}" ;;
  esac
}

is_wsl_here() {
  [[ "${IS_WSL:-false}" == "true" ]]
}

# Añadir $HOME/.local/bin de forma única
add_path_front_unique "$HOME/.local/bin"

if [[ "$OS_TYPE" == "windows" ]]; then
  export SCOOP_DIR="$HOME/scoop"
  add_path_front_unique "$SCOOP_DIR/shims"
  add_path_front_unique "$SCOOP_DIR/apps/scoop/current/bin"
fi

scoop_path() {
  local app="$1"
  echo "${SCOOP_DIR:-$HOME/scoop}/apps/$app/current"
}

# Añade ~/.cargo/bin al PATH cuando estemos en WSL (una sola vez)
if { [ "${IS_WSL:-false}" = "true" ] || is_wsl_here; } && [ -d "$HOME/.cargo/bin" ]; then
  add_path_front_unique "$HOME/.cargo/bin"
fi

normalize_path() {
  # Elimina entradas vacías y duplicados, preservando orden (robusto con espacios)
  PATH="$({
    printf '%s' "$PATH" |
      awk -v RS=':' '
        length($0) && !seen[$0]++ {
          out = (out ? out ":" : "") $0
        }
        END { print out }
      '
  })"
}

normalize_path
export PATH

