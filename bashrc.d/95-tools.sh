# Función para detectar el gestor de paquetes
detect_package_manager() {
  for pm in scoop apt dnf pacman zypper brew; do
    if command -v "$pm" &>/dev/null; then
      echo "$pm"
      return
    fi
  done
  echo "none"
}

# Función para caché de binarios
declare -A BIN_CACHE
is_installed() {
  local exe="$1"
  [[ -n "${BIN_CACHE[$exe]}" ]] && return 0
  if command -v "$exe" &>/dev/null; then
    BIN_CACHE["$exe"]=1
    return 0
  fi
  return 1
}

tools() {
  local ACTION="${1:-doctor}"
  local FILTER="${2:-}"  # Opción para filtrar por herramienta

  local TOOLS=(
    "git         git         git         git         git         git"
    "fzf         fzf         fzf         fzf         fzf         fzf"
    "fd          fd          fd-find     fd-find     fd          fd"
    "ripgrep     rg          ripgrep     ripgrep     ripgrep     ripgrep"
    "delta       delta       git-delta   git-delta   delta       git-delta"
    "bat         bat         bat         bat         bat         bat"
    "exa         exa         exa         exa         exa         exa"
    "starship    starship    starship    starship    starship    starship"
    "zoxide      zoxide      zoxide      zoxide      zoxide      zoxide"
  )

  declare -A PM_INDEX=( [scoop]=0 [apt]=2 [dnf]=3 [pacman]=4 [zypper]=2 [brew]=5 )

  local PM
  PM=$(detect_package_manager)

  if [[ "$PM" == "none" ]]; then
    echo "❌ No se detectó ningún gestor de paquetes compatible."
    return 1
  fi

  echo "🧰 Acción: $ACTION  | Gestor: $PM"

  case "$ACTION" in
    doctor)
      printf "\n%-12s %-10s %s\n" "Herramienta" "Estado" "Versión"
      echo "-----------------------------------------------"
      for line in "${TOOLS[@]}"; do
        read -r name exe _ <<< "$line"
        [[ -n "$FILTER" && "$FILTER" != "$name" ]] && continue
        if is_installed "$exe"; then
          version=$("$exe" --version 2>/dev/null | head -n 1)
          printf "✅ %-12s OK        %s\n" "$name" "$version"
        else
          printf "❌ %-12s FALTA     (%s)\n" "$name" "$exe"
        fi
      done
      ;;
    install)
      echo "📦 Instalando herramientas faltantes..."
      local TO_INSTALL=()
      for line in "${TOOLS[@]}"; do
        read -r name exe scoop apt dnf pac brew <<< "$line"
        [[ -n "$FILTER" && "$FILTER" != "$name" ]] && continue
        if ! is_installed "$exe"; then
          index=${PM_INDEX[$PM]}
          pkg_name=$(echo "$line" | awk -v i=$((index+1)) '{ print $i }')
          TO_INSTALL+=("$pkg_name")
        fi
      done

      if [[ "${#TO_INSTALL[@]}" -eq 0 ]]; then
        echo "🎉 Todo está instalado. No hay nada que hacer."
        return 0
      fi

      echo "🔧 Instalando: ${TO_INSTALL[*]}"
      case "$PM" in
        scoop)  scoop install "${TO_INSTALL[@]}" ;;
        apt)    sudo apt update && sudo apt install -y "${TO_INSTALL[@]}" ;;
        dnf)    sudo dnf install -y "${TO_INSTALL[@]}" ;;
        pacman) sudo pacman -S --noconfirm "${TO_INSTALL[@]}" ;;
        zypper) sudo zypper install -y "${TO_INSTALL[@]}" ;;
        brew)   brew install "${TO_INSTALL[@]}" ;;
      esac
      ;;
    update)
      echo "🔄 Actualizando herramientas..."
      case "$PM" in
        scoop)  scoop update '*' ;;
        apt)    sudo apt update && sudo apt upgrade -y ;;
        dnf)    sudo dnf upgrade --refresh -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
        zypper) sudo zypper refresh && sudo zypper update -y ;;
        brew)   brew update && brew upgrade ;;
      esac
      ;;
    *)
      echo "❓ Uso: tools {doctor|install|update} [filtro]"
      return 1
      ;;
  esac
}

# Autocompletado para la función tools
_tools_completions() {
  local options="doctor install update"
  COMPREPLY=($(compgen -W "$options" -- "${COMP_WORDS[1]}"))
}

complete -F _tools_completions tools