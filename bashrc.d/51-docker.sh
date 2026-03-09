# ───────────────────────────────────────────────────────────────
# DOCKER UTILITIES
# ───────────────────────────────────────────────────────────────
# Funciones y aliases para facilitar el trabajo con Docker
# 
# Funciones disponibles:
#   dockexec    - Ejecutar comando en contenedor (interactivo si no se especifica)
#   docklogs    - Ver logs de contenedor en tiempo real (interactivo si no se especifica)
#   dockclean   - Limpiar sistema Docker completo
#   dockenter   - Selector interactivo para entrar en contenedores (interactivo si no se especifica)
#
# Aliases:
#   de          - Alias para dockenter
#   dex         - Alias para dockexec
#   dlogs       - Alias para docklogs
# ───────────────────────────────────────────────────────────────

dockexec() {
  local container_name="$1"
  local command_to_run
  
  # Si no se especifica contenedor, usar fzf para seleccionar
  if [[ -z "$container_name" ]]; then
    # Verifica que docker y fzf están disponibles
    for cmd in docker fzf; do
      if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ '$cmd' no está instalado."
        return 1
      fi
    done

    # Obtiene lista de contenedores activos
    local container
    container=$(docker ps --format '{{.Names}} ({{.Image}})' | fzf --prompt="Selecciona un contenedor: " --height=40% --border --exit-0)

    # Si el usuario canceló
    [[ -z "$container" ]] && {
      echo "❎ No se seleccionó ningún contenedor."
      return 0
    }

    # Extrae solo el nombre del contenedor (antes del primer espacio)
    container_name="${container%% *}"
    
    # Pide el comando a ejecutar
    echo -n "💻 Comando a ejecutar (Enter para bash): "
    read -r command_to_run
    [[ -z "$command_to_run" ]] && command_to_run="/bin/bash"
    
    echo "⚡ Ejecutando '$command_to_run' en $container_name ..."
    docker exec -it "$container_name" bash -c "$command_to_run"
  else
    # Modo tradicional: contenedor especificado como primer parámetro
    if [[ $# -eq 1 ]]; then
      # Solo se especificó el contenedor, usar bash por defecto
      echo "🚪 Entrando en $container_name ..."
      docker exec -it "$container_name" bash 2>/dev/null || docker exec -it "$container_name" sh
    else
      # Se especificó contenedor y comando
      echo "⚡ Ejecutando comando en $container_name ..."
      docker exec -it "$container_name" "${@:2}"
    fi
  fi
}

docklogs() {
  local container_name="$1"
  
  # Si no se especifica contenedor, usar fzf para seleccionar
  if [[ -z "$container_name" ]]; then
    # Verifica que docker y fzf están disponibles
    for cmd in docker fzf; do
      if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ '$cmd' no está instalado."
        return 1
      fi
    done

    # Obtiene lista de contenedores activos
    local container
    container=$(docker ps --format '{{.Names}} ({{.Image}})' | fzf --prompt="Selecciona un contenedor: " --height=40% --border --exit-0)

    # Si el usuario canceló
    [[ -z "$container" ]] && {
      echo "❎ No se seleccionó ningún contenedor."
      return 0
    }

    # Extrae solo el nombre del contenedor (antes del primer espacio)
    container_name="${container%% *}"
  fi

  echo "📋 Mostrando logs de $container_name ..."
  docker logs -f "$container_name"
}

dockclean() {
  docker system prune -af --volumes
}

dockenter() {
  local container_name="$1"
  
  # Si no se especifica contenedor, usar fzf para seleccionar
  if [[ -z "$container_name" ]]; then
    # Verifica que docker y fzf están disponibles
    for cmd in docker fzf; do
      if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ '$cmd' no está instalado."
        return 1
      fi
    done

    # Obtiene lista de contenedores activos
    local container
    container=$(docker ps --format '{{.Names}} ({{.Image}})' | fzf --prompt="Selecciona un contenedor: " --height=40% --border --exit-0)

    # Si el usuario canceló
    [[ -z "$container" ]] && {
      echo "❎ No se seleccionó ningún contenedor."
      return 0
    }

    # Extrae solo el nombre del contenedor (antes del primer espacio)
    container_name="${container%% *}"
  fi

  echo "🚪 Entrando en $container_name ..."
  docker exec -it "$container_name" bash 2>/dev/null || docker exec -it "$container_name" sh
}

# Alias para dockenter
alias de='dockenter'
# Alias para dockexec
alias dex='dockexec'
# Alias para docklogs
alias dlogs='docklogs'

# 🐳 Alias de inspección rápida
if command -v docker >/dev/null 2>&1; then
  alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
  alias dtop='docker stats --no-stream'
  alias dstopall='docker ps -q | xargs -r docker stop'
  alias drm='docker container prune -f'
  alias dri='docker image prune -a -f'
fi