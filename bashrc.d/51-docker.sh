dockexec() {
  docker exec -it "$1" "${@:2:-/bin/bash}"
}

docklogs() {
  docker logs -f "$1"
}

dockclean() {
  docker system prune -af --volumes
}

dockenter() {
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
  local container_name="${container%% *}"

  echo "🚪 Entrando en $container_name ..."
  docker exec -it "$container_name" bash 2>/dev/null || docker exec -it "$container_name" sh
}

# Alias para dockenter
alias de='dockenter'