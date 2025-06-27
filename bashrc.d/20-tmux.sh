if [[ "$OS_TYPE" != "windows" || "$IS_WSL" == "true" ]]; then
  if command -v tmux >/dev/null 2>&1; then
    export TMUX_AUTOSTART=true

    alias tl='tmux ls'
    alias treload='tmux source-file ~/.tmux.conf && echo "🔁 tmux recargado"'
    tn() { tmux new -s "${1:-dev}"; }
    ta() { tmux attach -t "${1:-main}"; }
    tk() { tmux kill-session -t "$1"; }

    if [[ -z "$TMUX" && "$TMUX_AUTOSTART" == "true" ]]; then
      if tmux has-session -t main 2>/dev/null; then
        tmux attach -t main
      else
        tmux new-session -s main
      fi
    fi
  fi
fi
