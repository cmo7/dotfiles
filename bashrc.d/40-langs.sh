# Detecta e instala lenguajes de programación

# Función para detectar el gestor de paquetes (reutilizada de tools)
detect_package_manager() {
  for pm in scoop apt dnf pacman zypper brew; do
    if command -v "$pm" &>/dev/null; then
      echo "$pm"
      return
    fi
  done
  echo "none"
}

# Función para caché de binarios (reutilizada de tools)
declare -A LANG_BIN_CACHE
is_lang_installed() {
  local exe="$1"
  [[ -n "${LANG_BIN_CACHE[$exe]}" ]] && return 0
  if command -v "$exe" &>/dev/null; then
    LANG_BIN_CACHE["$exe"]=1
    return 0
  fi
  return 1
}

# Función para obtener versión de lenguajes
get_lang_version() {
  local name="$1"
  local exe="$2"
  
  case "$name" in
    "python3")    python3 --version 2>/dev/null | cut -d' ' -f2 ;;
    "python2")    python2 --version 2>&1 | cut -d' ' -f2 ;;
    "node")       node --version 2>/dev/null | sed 's/^v//' ;;
    "go")         go version 2>/dev/null | awk '{print $3}' | sed 's/go//' ;;
    "rust")       rustc --version 2>/dev/null | awk '{print $2}' ;;
    "java")       java -version 2>&1 | head -n1 | awk -F '"' '{print $2}' ;;
    "gcc")        gcc --version 2>/dev/null | head -n1 | awk '{print $4}' ;;
    "clang")      clang --version 2>/dev/null | head -n1 | awk '{print $3}' ;;
    "ruby")       ruby --version 2>/dev/null | awk '{print $2}' ;;
    "php")        php --version 2>/dev/null | head -n1 | awk '{print $2}' ;;
    "dotnet")     dotnet --version 2>/dev/null ;;
    "lua")        lua -v 2>&1 | awk '{print $2}' ;;
    "perl")       perl --version 2>/dev/null | grep -oP 'v\K[0-9.]+' | head -n1 ;;
    "r")          R --version 2>/dev/null | head -n1 | awk '{print $3}' ;;
    "scala")      scala -version 2>&1 | awk '{print $5}' ;;
    "kotlin")     kotlin -version 2>&1 | awk '{print $3}' ;;
    "swift")      swift --version 2>/dev/null | head -n1 | awk '{print $4}' ;;
    *)            $exe --version 2>/dev/null | head -n1 ;;
  esac
}

langs() {
  local ACTION="${1:-doctor}"
  local FILTER="${2:-}"  # Opción para filtrar por lenguaje

  #   Nombre       Ejecutable  Scoop           APT                DNF                Pacman          Zypper              Brew
  #   ----------   ----------  --------------- ------------------ ------------------ --------------- ------------------- --------------------
  local LANGS=(
    "python3     python3     python          python3            python3            python          python3             python3"
    "python2     python2     -               python2            -                  python2         python2             python@2"
    "node        node        nodejs          nodejs             nodejs             nodejs          nodejs18            node"
    "go          go          go              golang-go          golang             go              go                  go"
    "rust        rustc       rust            rustc              rust               rust            rust                rust"
    "java        java        openjdk         default-jdk        java-17-openjdk    jdk-openjdk     java-17-openjdk     openjdk"
    "gcc         gcc         gcc             gcc                gcc                gcc             gcc                 gcc"
    "clang       clang       llvm            clang              clang              clang           llvm17              llvm"
    "ruby        ruby        ruby            ruby               ruby               ruby            ruby                ruby"
    "php         php         php             php                php                php             php8                php"
    "dotnet      dotnet      dotnet-sdk      dotnet-sdk-8.0     dotnet-sdk-8.0     dotnet-sdk      dotnet-sdk-8_0      dotnet"
    "lua         lua         lua             lua5.4             lua                lua             lua54               lua"
    "perl        perl        perl            perl               perl               perl            perl                perl"
    "r           R           r               r-base             R                  r               R-base-devel        r"
    "scala       scala       -               scala              -                  scala           -                   scala"
    "kotlin      kotlin      -               kotlin             -                  kotlin          -                   kotlin"
    "swift       swift       -               swift              swift              swift           swift               swift"
  )

  declare -A PM_INDEX=( [scoop]=2 [apt]=3 [dnf]=4 [pacman]=5 [zypper]=6 [brew]=7 )

  local PM
  PM=$(detect_package_manager)

  if [[ "$PM" == "none" ]]; then
    echo "❌ No se detectó ningún gestor de paquetes compatible."
    return 1
  fi

  echo "🔤 Acción: $ACTION  | Gestor: $PM"

  case "$ACTION" in
    doctor)
      printf "\n%-12s %-10s %s\n" "Lenguaje" "Estado" "Versión"
      echo "-----------------------------------------------"
      for line in "${LANGS[@]}"; do
        read -r name exe scoop apt dnf pac zyp brew <<< "$line"
        [[ -n "$FILTER" && "$FILTER" != "$name" ]] && continue
        
        # Verificar si el lenguaje está disponible para el gestor actual
        case "$PM" in
          scoop)  pkg_name="$scoop" ;;
          apt)    pkg_name="$apt" ;;
          dnf)    pkg_name="$dnf" ;;
          pacman) pkg_name="$pac" ;;
          zypper) pkg_name="$zyp" ;;
          brew)   pkg_name="$brew" ;;
        esac
        
        if [[ "$pkg_name" == "-" ]]; then
          printf "⚠️ %-12s OMITIDO   (no disponible en %s)\n" "$name" "$PM"
          continue
        fi
        
        if is_lang_installed "$exe"; then
          version=$(get_lang_version "$name" "$exe")
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
      echo "📦 Instalando lenguajes faltantes..."
      local TO_INSTALL=()
      for line in "${LANGS[@]}"; do
        read -r name exe scoop apt dnf pac zyp brew <<< "$line"
        [[ -n "$FILTER" && "$FILTER" != "$name" ]] && continue
        
        # Verificar si el lenguaje está disponible para el gestor actual
        case "$PM" in
          scoop)  pkg_name="$scoop" ;;
          apt)    pkg_name="$apt" ;;
          dnf)    pkg_name="$dnf" ;;
          pacman) pkg_name="$pac" ;;
          zypper) pkg_name="$zyp" ;;
          brew)   pkg_name="$brew" ;;
        esac
        
        if [[ "$pkg_name" == "-" ]]; then
          continue  # Omitir lenguajes no disponibles
        fi
        
        if ! is_lang_installed "$exe"; then
          TO_INSTALL+=("$pkg_name")
        fi
      done

      if [[ "${#TO_INSTALL[@]}" -eq 0 ]]; then
        echo "🎉 Todos los lenguajes están instalados. No hay nada que hacer."
        return 0
      fi

      echo "🔧 Instalando: ${TO_INSTALL[*]}"
      case "$PM" in
        scoop)  
          for pkg in "${TO_INSTALL[@]}"; do
            echo "📦 Instalando $pkg..."
            scoop install "$pkg" || echo "⚠️  Falló la instalación de $pkg"
          done
          ;;
        apt)    
          sudo apt update && sudo apt install -y "${TO_INSTALL[@]}" 
          ;;
        dnf)    
          sudo dnf install -y --skip-unavailable "${TO_INSTALL[@]}" 
          ;;
        pacman) 
          sudo pacman -S --noconfirm "${TO_INSTALL[@]}" 
          ;;
        zypper) 
          sudo zypper install -y "${TO_INSTALL[@]}" 
          ;;
        brew)   
          for pkg in "${TO_INSTALL[@]}"; do
            echo "📦 Instalando $pkg..."
            brew install "$pkg" || echo "⚠️  Falló la instalación de $pkg"
          done
          ;;
      esac
      ;;
    update)
      echo "🔄 Actualizando lenguajes..."
      case "$PM" in
        scoop)  scoop update '*' ;;
        apt)    sudo apt update && sudo apt upgrade -y ;;
        dnf)    sudo dnf upgrade --refresh -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
        zypper) sudo zypper refresh && sudo zypper update -y ;;
        brew)   brew update && brew upgrade ;;
      esac
      ;;
    list)
      echo "📋 Lenguajes disponibles:"
      for line in "${LANGS[@]}"; do
        read -r name exe scoop apt dnf pac zyp brew <<< "$line"
        
        # Verificar si el lenguaje está disponible para el gestor actual
        case "$PM" in
          scoop)  pkg_name="$scoop" ;;
          apt)    pkg_name="$apt" ;;
          dnf)    pkg_name="$dnf" ;;
          pacman) pkg_name="$pac" ;;
          zypper) pkg_name="$zyp" ;;
          brew)   pkg_name="$brew" ;;
        esac
        
        if [[ "$pkg_name" != "-" ]]; then
          printf "  %-12s (%s)\n" "$name" "$exe"
        fi
      done
      ;;
    *)
      echo "❓ Uso: langs {doctor|install|update|list} [filtro]"
      echo ""
      echo "Ejemplos:"
      echo "  langs doctor          # Ver estado de todos los lenguajes"
      echo "  langs doctor python3  # Ver solo el estado de Python 3"
      echo "  langs install         # Instalar lenguajes faltantes"
      echo "  langs install go      # Instalar solo Go"
      echo "  langs update          # Actualizar todos los lenguajes"
      echo "  langs list            # Listar lenguajes disponibles"
      return 1
      ;;
  esac
}

# Autocompletado para la función langs
_langs_completions() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  if [[ $COMP_CWORD -eq 1 ]]; then
    local options="doctor install update list"
    COMPREPLY=($(compgen -W "$options" -- "$cur"))
  elif [[ $COMP_CWORD -eq 2 ]]; then
    local langs="python3 python2 node go rust java gcc clang ruby php dotnet lua perl r scala kotlin swift"
    COMPREPLY=($(compgen -W "$langs" -- "$cur"))
  fi
}

complete -F _langs_completions langs