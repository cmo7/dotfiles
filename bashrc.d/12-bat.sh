# bat - A cat clone with syntax highlighting
if command -v bat >/dev/null 2>&1; then
  export FORCE_COLOR=true
  export BAT_THEME="Dracula"
  alias cat='bat'
  alias bcat='bat --plain'  # bat sin números de línea ni decoraciones
  alias batl='bat --language'  # especificar lenguaje manualmente
fi
