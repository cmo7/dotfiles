dockerenter() {
  local name="$1"
  [[ -z "$name" ]] && { echo "❌ Uso: dockerenter <nombre>"; return 1; }
  docker exec -it "$name" /bin/bash 2>/dev/null || docker exec -it "$name" /bin/sh
}

dockerclean() {
  echo "🧽 Limpiando contenedores, imágenes, redes y volúmenes no usados..."
  docker system prune -a --volumes -f
}

# 🐳 Alias simples
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dtop='docker stats --no-stream'
alias dstopall='docker ps -q | xargs -r docker stop'
alias drm='docker container prune -f'
alias dri='docker image prune -a -f'
alias dlogs='docker logs -f --tail 50'

# 🧠 Autocompletado para funciones
_complete_container_names() {
  COMPREPLY=( $(compgen -W "$(docker ps --format '{{.Names}}')" -- "${COMP_WORDS[1]}") )
}
complete -F _complete_container_names dockerenter
complete -F _complete_container_names dockerlog
