# fzf - Command-line fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --multi --cycle"
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
  
  # Alias básicos
  alias fzfp='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
  alias fzft='fzf --preview "file {}"'

  # Funciones específicas para tmux
  if command -v tmux >/dev/null 2>&1; then
    # Crear nueva sesión tmux desde un directorio git
    tgit() {
      local dir
      dir=$(find ~ -name .git -type d -prune -exec dirname {} \; 2>/dev/null | fzf --prompt="🌿 Repo git: " --height=40% --border --preview='echo {} && echo "---" && ls -la {} | head -10')
      if [[ -n "$dir" ]]; then
        local session_name=$(basename "$dir")
        if tmux has-session -t "$session_name" 2>/dev/null; then
          tmux attach -t "$session_name"
        else
          tmux new-session -d -s "$session_name" -c "$dir"
          tmux attach -t "$session_name"
        fi
      fi
    }

    # Buscar y abrir archivo en tmux con editor
    tedit() {
      if [[ -n "$TMUX" ]]; then
        local file
        file=$(find . -type f -not -path '*/\.*' | fzf --prompt="✏️ Editar: " --height=40% --border --preview="bat --style=numbers --color=always --line-range :500 {}")
        [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
      else
        echo "⚠️  Esta función funciona mejor desde dentro de tmux"
        local file
        file=$(find . -type f -not -path '*/\.*' | fzf --prompt="✏️ Editar: " --height=40% --border --preview="bat --style=numbers --color=always --line-range :500 {}")
        [[ -n "$file" ]] && ${EDITOR:-vim} "$file"
      fi
    }

    # Buscar en el historial de comandos y ejecutar en tmux
    tcmd() {
      if [[ -n "$TMUX" ]]; then
        local cmd
        cmd=$(fc -l 1 | fzf --prompt="⌨️ Comando: " --height=40% --border --tac | sed 's/^ *[0-9]* *//')
        [[ -n "$cmd" ]] && tmux send-keys "$cmd" Enter
      else
        echo "⚠️  Esta función solo funciona desde dentro de tmux"
      fi
    }
  fi
fi
