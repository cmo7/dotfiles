hgrep() {
  history | grep --color=always "$@"
}

fedit() {
  fd --hidden --follow --exclude .git . "${1:-.}" | fzf | xargs -r "${EDITOR:-nvim}"
}

search() {
  RG_PREFIX="rg --column --line-number --no-heading --color=always"
  FZF_DEFAULT_COMMAND="$RG_PREFIX ''" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
        --preview 'bat --style=numbers --color=always --line-range :500 {1}' \
        --delimiter : \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
}
