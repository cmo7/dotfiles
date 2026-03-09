# bat - A cat clone with syntax highlighting
# On Debian/Ubuntu, bat is installed as `batcat`
_bat_cmd=""
if command -v batcat >/dev/null 2>&1; then
  _bat_cmd="batcat"
elif command -v bat >/dev/null 2>&1; then
  _bat_cmd="bat"
fi

if [[ -n "$_bat_cmd" ]]; then
  export FORCE_COLOR=true
  export BAT_THEME="Dracula"
  alias bat="$_bat_cmd"
  alias cat='bat'
  alias bcat='bat --plain'  # bat sin números de línea ni decoraciones
  alias batl='bat --language'  # especificar lenguaje manualmente
fi
unset _bat_cmd
