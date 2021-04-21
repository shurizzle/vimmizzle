#!/bin/sh

mkdir -p ~/.vim/bundle
mkdir ~/.config/nvim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
