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

	# link the init.vim file and coc-settings 
	ln -s "$(pwd)/nvim/init.vim" ~/.config/nvim/init.vim
	ln -s "$(pwd)/nvim/coc-settings.json" ~/.config/nvim/coc-settings.json

	echo "added ~/.config/nvim/init.vim"
	echo "added ~/.config/nvim/coc-settings.json"
	echo "Run :PlugInstall inside nvim"

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
