# eza - Modern replacement for ls (maintained fork of exa)
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -la --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --level=2 --icons'
  alias ltl='eza --tree --level=3 -la --icons'
elif command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons'
  alias ll='exa -la --icons'
  alias la='exa -la --icons'
  alias lt='exa --tree --level=2 --icons'
  alias ltl='exa --tree --level=3 -la --icons'
else
  # macOS BSD ls uses -G for color; GNU ls uses --color=auto
  if [[ "${OS_TYPE:-}" == "mac" ]]; then
    alias ls='ls -G'
    alias ll='ls -la -G'
    alias la='ls -la -G'
  else
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    alias la='ls -la --color=auto'
  fi
fi
