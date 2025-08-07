#!/usr/bin/env bash
link(){
	if [ ! -e "$2" ]; then
		echo "linking '$1' as '$2'" 
		if [ -z "$3" ]; then
			ln -sf "$1" "$2"
		else
			sudo ln -sf "$1" "$2"
		fi
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
link "$DIR/.zshrc" "$HOME/.zshrc"

link "$DIR/.touchpad.conf" "/etc/X11/xorg.conf.d/300-touchpad.conf" "yes"
