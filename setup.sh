#!/bin/sh

mkdir -p ~/.vim/plugged
mkdir -p ~/.config/nvim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
mkdir -p ~/.vim/plugged/
git clone https://github.com/junegunn/vim-plug ~/.vim/plugged/vim-plug
