#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ll='exa -l --icons'
alias ls='exa --icons'
alias grep='grep --color=auto'
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

#Path
export PATH="$HOME/bin:$PATH"

# Automatic tmux session
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"

