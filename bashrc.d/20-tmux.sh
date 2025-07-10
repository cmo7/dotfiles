if [[ "$OS_TYPE" != "windows" || "$IS_WSL" == "true" ]]; then
  if command -v tmux >/dev/null 2>&1; then
    export TMUX_AUTOSTART=true

    alias tl='tmux ls'
    alias treload='tmux source-file ~/.tmux.conf && echo "🔁 tmux recargado"'
    tn() { tmux new -s "${1:-dev}"; }
    ta() { tmux attach -t "${1:-main}"; }
    tk() { tmux kill-session -t "$1"; }

    # Funciones con fzf para tmux
    if command -v fzf >/dev/null 2>&1; then
      # Seleccionar y adjuntar a una sesión con fzf
      taf() {
        local session
        session=$(tmux ls -F "#{session_name}: #{session_windows} windows #{?session_attached,(attached),}" 2>/dev/null | fzf --prompt="📺 Sesión: " --height=40% --border | cut -d: -f1)
        [[ -n "$session" ]] && tmux attach -t "$session"
      }

      # Seleccionar y matar una sesión con fzf
      tkf() {
        local session
        session=$(tmux ls -F "#{session_name}: #{session_windows} windows #{?session_attached,(attached),}" 2>/dev/null | fzf --prompt="💀 Matar sesión: " --height=40% --border | cut -d: -f1)
        [[ -n "$session" ]] && tmux kill-session -t "$session"
      }

      # Cambiar entre sesiones con fzf (desde dentro de tmux)
      tsf() {
        if [[ -n "$TMUX" ]]; then
          local session
          session=$(tmux ls -F "#{session_name}: #{session_windows} windows #{?session_attached,(attached),}" | grep -v "$(tmux display-message -p '#S:')" | fzf --prompt="🔄 Cambiar a: " --height=40% --border | cut -d: -f1)
          [[ -n "$session" ]] && tmux switch-client -t "$session"
        else
          echo "⚠️  Esta función solo funciona desde dentro de tmux"
        fi
      }

      # Crear nueva sesión con nombre usando fzf para directorios
      tnf() {
        local dir
        dir=$(find ~ -type d -name .git -prune -o -type d -print 2>/dev/null | head -50 | fzf --prompt="📁 Directorio: " --height=40% --border --preview='ls -la {}')
        if [[ -n "$dir" ]]; then
          local session_name=$(basename "$dir")
          tmux new-session -d -s "$session_name" -c "$dir"
          tmux attach -t "$session_name"
        fi
      }
    fi

    if [[ -z "$TMUX" && "$TMUX_AUTOSTART" == "true" ]]; then
      if tmux has-session -t main 2>/dev/null; then
        tmux attach -t main
      else
        tmux new-session -s main
      fi
    fi
  fi
fi
