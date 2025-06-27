# ripgrep - Line-oriented search tool
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
  alias rgg='rg --glob "!.git/*"'
  alias rgh='rg --heading --line-number'
  alias rgw='rg --word-regexp'
  alias rgi='rg --ignore-case'
  alias rgf='rg --files'
  alias rgn='rg --line-number'
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
  
  # Alias que requieren fzf
  if command -v fzf >/dev/null 2>&1; then
    alias rgfzf='rg --files | fzf'
  fi
fi
