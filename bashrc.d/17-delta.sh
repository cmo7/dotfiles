# delta - A syntax-highlighting pager for git
if command -v delta >/dev/null 2>&1; then
  export DELTA_FEATURES="side-by-side line-numbers decorations"
  export DELTA_THEME="Dracula"
  
  # Alias que requiere git
  if command -v git >/dev/null 2>&1; then
    alias dgit='git diff | delta'
  fi
fi
