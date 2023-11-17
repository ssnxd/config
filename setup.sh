#!/usr/bin/env bash

setup_nvim() {

	if ! command -v nvim &> /dev/null
	then 
		echo "[Warn] nvim executable not in path or not installed\n https://github.com/neovim/neovim/wiki/Installing-Neovim"
		echo "Install: https://github.com/neovim/neovim/wiki/Installing-Neovim"
	fi


	# Install package manager
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

	# link the nvim folder
	ln -s "$(pwd)/nvim" ~/.config/nvim

	echo "linked ~/.config/nvim"

	return 0
}

setup_tmux() {

	if ! command -v tmux &> /dev/null
	then
		echo "[Warn] tmux executable not in path or not installed\n https://github.com/tmux/tmux/wiki/Installing"
	fi

	ln -s "$(pwd)/tmux.conf" ~/.tmux.conf

	echo "added .tmux.conf"
	return 0
}

setup_tmux
setup_nvim
