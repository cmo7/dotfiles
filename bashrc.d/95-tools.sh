# Función para caché de binarios
declare -A BIN_CACHE
# Debian/Ubuntu alternative binary names for some tools
declare -A BIN_ALTERNATIVES=( [fd]="fdfind" [bat]="batcat" )
is_installed() {
  local exe="$1"
  [[ -n "${BIN_CACHE[$exe]}" ]] && return 0
  if command -v "$exe" &>/dev/null; then
    BIN_CACHE["$exe"]=1
    return 0
  fi
  local alt="${BIN_ALTERNATIVES[$exe]:-}"
  if [[ -n "$alt" ]] && command -v "$alt" &>/dev/null; then
    BIN_CACHE["$exe"]=1
    return 0
  fi
  return 1
}

tools() {
  local ACTION="${1:-doctor}"
  local FILTER="${2:-}"  # Opción para filtrar por herramienta

  #   Nombre       Ejecutable  Scoop       APT         DNF         Pacman      Zypper      Brew
  #   ----------   ----------  ----------  ----------  ----------  ----------  ----------  ----------
  local TOOLS=(
    "git         git         git         git         git         git         git         git"
    "fzf         fzf         fzf         fzf         fzf         fzf         fzf         fzf"
    "fd          fd          fd          fd-find     fd-find     fd          fd          fd"
    "ripgrep     rg          ripgrep     ripgrep     ripgrep     ripgrep     ripgrep     ripgrep"
    "delta       delta       delta       git-delta   git-delta   git-delta   git-delta   git-delta"
    "bat         bat         bat         bat         bat         bat         bat         bat"
    "eza         eza         eza         eza         eza         eza         eza         eza"
    "starship    starship    starship    starship    starship    starship    starship    starship"
    "zoxide      zoxide      zoxide      zoxide      zoxide      zoxide      zoxide      zoxide"
    "pv          pv          -           pv          pv          pv          pv          pv"
    "unzip       unzip       unzip       unzip       unzip       unzip       unzip       unzip"
    "7z          7z          7z          p7zip-full  p7zip       p7zip       p7zip       p7zip"
    "unrar       unrar       -           unrar       unrar       unrar       unrar       unrar"
    "curl        curl        curl        curl        curl        curl        curl        curl"
    "wget        wget        wget        wget        wget        wget        wget        wget"
    "jq          jq          jq          jq          jq          jq          jq          jq"
  )

  declare -A PM_INDEX=( [scoop]=2 [apt]=3 [dnf]=4 [pacman]=5 [zypper]=6 [brew]=7 )

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
        read -r name exe scoop apt dnf pac zyp brew <<< "$line"
        [[ -n "$FILTER" && "$FILTER" != "$name" ]] && continue
        
        # Verificar si la herramienta está disponible para el gestor actual
        index=${PM_INDEX[$PM]}
        pkg_name=$(echo "$line" | awk -v i=$index '{ print $i }')
        if [[ "$pkg_name" == "-" ]]; then
          printf "⚠️ %-12s OMITIDA   (no disponible en %s)\n" "$name" "$PM"
          continue
        fi
        
        if is_installed "$exe"; then
          version=$("$exe" --version 2>/dev/null | head -n 1)
          # Cropear la versión a máximo 40 caracteres
          if [[ ${#version} -gt 40 ]]; then
            version="${version:0:37}..."
          fi
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
        read -r name exe scoop apt dnf pac zyp brew <<< "$line"
        [[ -n "$FILTER" && "$FILTER" != "$name" ]] && continue
        
        # Verificar si la herramienta está disponible para el gestor actual
        index=${PM_INDEX[$PM]}
        pkg_name=$(echo "$line" | awk -v i=$index '{ print $i }')
        if [[ "$pkg_name" == "-" ]]; then
          continue  # Omitir herramientas no disponibles
        fi
        
        if ! is_installed "$exe"; then
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