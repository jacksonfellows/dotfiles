export EDITOR=vim
alias gvim=/Applications/MacVim.app/Contents/bin/gvim
alias gvimdiff=/Applications/MacVim.app/Contents/bin/gvimdiff

export HISTSIZE=10000
export HISTFILESIZE=10000

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

alias pwb='git branch | awk '"'"'/\*/ {print $2}'"'"''

alias dotfiles='/usr/bin/env git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
