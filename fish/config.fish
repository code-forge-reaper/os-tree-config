# vars/exports
set -x GIT_DISCOVERY_ACROSS_FILESYSTEM 1
# Check which neovim command is available and set the EDITOR accordingly
if test (command -v nvim)
    set -x EDITOR nvim
else if test (command -v neovim)
    set -x EDITOR neovim
else
    echo "Helix editor is not installed."
    echo "editor will be nano"
    set -x EDITOR nano
end

#if test (command -v thorium-browser)
#    set -x BROWSER thorium-browser
#else
#    echo "do you have thorium-browser installed?"
#end

if test (command -v brave)
    set -x BROWSER brave
else
    echo "do you have brave installed?"
end

set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -x FZF_ALT_C_OPTS "--preview 'eza -n --color=always {} | head -200'"
set -x LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$HOME/.libs/libs"
set -x HOMEBREW_AUTO_UPDATE_SECS 500
set -x HOMEBREW_NO_INSTALL_CLEANUP 1
set -x FONTCONFIG_PATH /etc/fonts
set -x HISTFILE "~/.fish_hist"
set -x TERM alacritty
set -x MYVIMRC "~/.vimrc"
set -x MYNVIMRC "~/.config/nvim/init.lua"
set -x TWEEGO_PATH "~/.storyformats"
set -x RUSTC_WRAPPER sccache
# set -x MANPAGER bat
set -x MANPAGER "nvim +Man!"

set -x ODIN_ROOT $HOME/git/odin

# paths
set -x PATH $HOME/.rbenv/shims $PATH
set -x PATH $PATH $HOME/bin $HOME/.config/emacs/bin $HOME/.local/share/gem/ruby/*/bin
set -x PATH /opt/brew/opt/pod2man/bin $PATH
set -x PATH /opt/brew/bin $PATH
set -x PATH $PATH ~/.local/bin/
set -x PATH $PATH /opt/android-sdk/platform-tools/
set -x PATH $HOME/scripts $PATH

# functions
function kitty-reload
    kill -SIGUSR1 (pidof kitty)
end

function original
    if test (count $argv) -eq 0
        echo "original:"
        echo "runs the original command, be it in /usr/bin /bin or in some other folder,"
        echo "should work with commands defined by zsh and/or bash"
        echo "Usage: original <command> [arguments]"
        return 1
    end

    set cmd $argv[1]
    set -e argv[1]
    command $cmd $argv
end

function whoowns
    if test (count $argv) -eq 0
        echo whoowns
        echo " shows you who is the owner of a file or folder"
        echo " e.g: ~/ owner's would be you, (whoami)"
        echo "whoowns <file or folder>"
        return 1
    end
    stat -c '%U' $argv[1]
end

function findEdit
    if test (count $argv) -eq 0
        echo "running fzf on current folder"
        edit $(fzf)
    else
        edit $(fzf $argv[1])
    end
end

function initD
    source ~/dlang/dmd-2.109.1/activate.fish
end

# aliases
alias ls="eza -l"
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

# dynamic initialization
fzf --fish | source
zoxide init --cmd cd fish | source
source (/usr/bin/starship init fish --print-full-init | psub)

# bun
set -x BUN_INSTALL $HOME/.bun
set -x PATH $BUN_INSTALL/bin $PATH


function fish_greeting
end

# Start X automatically on login
if test -z "$DISPLAY" -a (tty) = /dev/tty1
    startx
end

# pnpm
set -gx PNPM_HOME "/home/cross/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
