# aliases
alias ls="exa -l"
alias la="ls -a"
#alias ffrec="ffmpeg -f x11grab -i :0.0"
alias ffrec="ffmpeg -f x11grab -i :0.0 -f alsa -i default"

alias zshconf="$EDITOR ~/.zshrc; echo 'reloaded zsh'; exec zsh"
alias cat="bat"
# this can be chained, like: ../<other directory>
alias ..="cd .."

alias edit="$EDITOR"
# you can use this like: "$ e <filename>"
alias e="edit"

alias gcg="git config --global"
alias gas="git add .; git status --short"
alias emacscli="emacsclient"
alias ncm="ncmpcpp"
alias tree="tree -C"
