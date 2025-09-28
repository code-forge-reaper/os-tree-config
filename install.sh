#!/usr/bin/env bash
shouldUnlink=false # don't know if it should be called unlink or uninstall
for arg in "$@"; do
	if [ "$arg" = "-u" ]; then
		shouldUnlink=true
	fi
done

link(){
	if [ "$shouldUnlink" = true ]; then
		unlink "$2"
		return
	fi
	if [ ! -e "$2" ]; then
		echo "linking '$1' as '$2'" 
		if [ -w "$(dirname "$2")" ]; then
			    ln -sf "$1" "$2"
			else
			    sudo ln -sf "$1" "$2"
			fi
        else
		echo "cannot link '$1'"
	fi
}

#set -ex

#PACKAGES="alacritty rofi nitrogen picom dunst mpd emacs nodejs npm clang"
DIR="$(pwd)"
#echo $DIR
#yay -S $PACKAGES --needed
link "$DIR/.tmux.conf" "$HOME/.tmux.conf"
link "$DIR/.vimrc" "$HOME/.vimrc"
link "$DIR/i3/config" "$HOME/.config/i3/config"
link "$DIR/nvim" "$HOME/.config/nvim"
link "$DIR/zsh" "$HOME/.config/zsh"
link "$DIR/emacs" "$HOME/.config/emacs"
link "$DIR/scripts" "$HOME/scripts"
link "$DIR/fish" "$HOME/.config/fish"

link "$DIR/.zshrc" "$HOME/.zshrc"

link "$DIR/.touchpad.conf" "/etc/X11/xorg.conf.d/300-touchpad.conf"
