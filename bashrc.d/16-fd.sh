# fd - Simple, fast and user-friendly alternative to find
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
  alias ff='fd --type f'
  alias ffd='fd --type d'
  alias ffh='fd --hidden'
  alias ffl='fd --follow'
  export FD_OPTIONS="--hidden --follow --exclude .git"
  
  # Alias que requieren fzf
  if command -v fzf >/dev/null 2>&1; then
    alias fzf-fd='fd --hidden --follow --exclude .git | fzf'
    alias fdf='fd --type f | fzf'
    alias fdd='fd --type d | fzf'
  fi
fi
