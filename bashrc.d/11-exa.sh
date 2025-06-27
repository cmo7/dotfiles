# exa - Modern replacement for ls
if command -v exa >/dev/null 2>&1; then
  alias ls='exa --icons'
  alias ll='exa -la --icons'
  alias la='exa -la --icons'
  alias lt='exa --tree --level=2 --icons'
  alias ltl='exa --tree --level=3 -la --icons'
else
  alias ls='ls --color=auto'
  alias ll='ls -la --color=auto'
  alias la='ls -la --color=auto'
fi
