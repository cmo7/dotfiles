# ================================
# CONFIGURACIÓN DE EDITORES
# ================================

# Lista de editores en orden de prioridad
# Formato: "comando:argumentos:tipo:descripción"
# Tipos: terminal, gui, hybrid (funciona en ambos)
declare -a EDITOR_CANDIDATES=(
  "nvim::terminal:Neovim"
  "hx::terminal:Helix"
  "vim::terminal:Vim"
  "micro::terminal:Micro"
  "code:code --wait:gui:Visual Studio Code"
  "subl:subl --wait:gui:Sublime Text"
  "atom:atom --wait:gui:Atom"
  "nano::terminal:Nano"
  "joe::terminal:Joe"
  "vi::terminal:Vi (fallback)"
)

# Lista separada para editores gráficos (VISUAL)
declare -a VISUAL_CANDIDATES=(
  "code:code --wait:gui:Visual Studio Code"
  "subl:subl --wait:gui:Sublime Text"
  "atom:atom --wait:gui:Atom"
  "nvim::terminal:Neovim"
  "vim::terminal:Vim"
  "emacs:emacs -nw:terminal:Emacs"
)

# ================================
# FUNCIONES AUXILIARES
# ================================

# Función para detectar si estamos en entorno gráfico
_is_graphical_env() {
  [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" || "$TERM_PROGRAM" == "vscode" ]]
}

# Función para encontrar y configurar editor
_find_editor() {
  local candidates=("$@")
  local found_editor=""
  
  for candidate in "${candidates[@]}"; do
    IFS=':' read -r cmd args type desc <<< "$candidate"
    
    # Verificar si el comando existe
    if command -v "$cmd" >/dev/null 2>&1; then
      # Si es GUI, verificar entorno gráfico
      if [[ "$type" == "gui" ]] && ! _is_graphical_env; then
        continue
      fi
      
      # Usar argumentos personalizados o comando simple
      if [[ -n "$args" ]]; then
        found_editor="$args"
      else
        found_editor="$cmd"
      fi
      break
    fi
  done
  
  echo "$found_editor"
}

# ================================
# CONFIGURACIÓN PRINCIPAL
# ================================

# Detectar el editor preferido y configurarlo
# Solo configurar si no están definidos previamente
if [[ -z "$EDITOR" ]]; then
  EDITOR=$(_find_editor "${EDITOR_CANDIDATES[@]}")
  export EDITOR
fi

# Configurar VISUAL para editores gráficos (usado por utilidades como git, crontab, etc.)
if [[ -z "$VISUAL" ]]; then
  VISUAL=$(_find_editor "${VISUAL_CANDIDATES[@]}")
  # Si no encontramos editor gráfico, usar el mismo que EDITOR
  if [[ -z "$VISUAL" ]]; then
    VISUAL="$EDITOR"
  fi
  export VISUAL
fi

# ================================
# CONFIGURACIÓN ADICIONAL
# ================================

# Para git: asegurar que use el editor correcto
export GIT_EDITOR="$EDITOR"

# Alias útiles para edición rápida
alias edit='$EDITOR'
# Nota: función vedit() está definida en 50-utils.sh

# ================================
# UTILIDADES DE DEPURACIÓN
# ================================

# Función para mostrar la configuración actual de editores
show_editor_config() {
  echo "📝 Configuración actual de editores:"
  echo "   EDITOR:     $EDITOR"
  echo "   VISUAL:     $VISUAL"
  echo "   GIT_EDITOR: $GIT_EDITOR"
  echo ""
  echo "🔍 Editores disponibles en el sistema:"
  
  for candidate in "${EDITOR_CANDIDATES[@]}"; do
    IFS=':' read -r cmd args type desc <<< "$candidate"
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "   ✅ $desc ($cmd)"
    else
      echo "   ❌ $desc ($cmd) - no disponible"
    fi
  done
  
  echo ""
  echo "🖥️  Entorno gráfico: $(_is_graphical_env && echo "Sí" || echo "No")"
}

# Función para reconfigurar editores (útil después de instalar uno nuevo)
reconfigure_editors() {
  unset EDITOR VISUAL GIT_EDITOR
  source "$HOME/.bashrc"
  echo "🔄 Editores reconfigurados"
  show_editor_config
} 