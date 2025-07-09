if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
  alias j='z'
  zi() {
    zoxide query -l | fzf --height=40% --reverse --preview 'ls -la {}' | xargs -r cd
  }
fi
