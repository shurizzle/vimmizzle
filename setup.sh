#!/bin/sh

set -eux

mkdir -p ~/.vim/plugged
mkdir -p ~/.config/nvim
[ -f ~/.vim/vimrc ] || ln -s ~/.vim/vimrc ~/.vimrc
[ -f ~/.config/nvim/init.vim ] || ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
mkdir -p ~/.vim/plugged/
[ -d ~/.vim/plugged/vim-plug/.git ] || git clone https://github.com/junegunn/vim-plug ~/.vim/plugged/vim-plug
