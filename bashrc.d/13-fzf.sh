# fzf - Command-line fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --multi --cycle"
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
  
  # Alias básicos
  alias fzfp='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
  alias fzft='fzf --preview "file {}"'
fi
