set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Plugins

Plugin 'cocopon/iceberg.vim'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'

Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-projectionist'
Plugin 'noahfrederick/vim-composer'
Plugin 'noahfrederick/vim-laravel'

Plugin 'pangloss/vim-javascript'
Plugin 'leafgarland/typescript-vim'

call vundle#end()

syntax enable
filetype plugin indent on

colo iceberg

set exrc
set secure
set viminfo+=!

set list listchars=tab:\ ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«

map <S-n> :NERDTreeToggle<cr>

map t :tabnew<CR>
map <C-n> :tabn<CR>
map <C-p> :tabp<CR>

autocmd BufWritePre * :%s/\s\+$//e

set showcmd
set mouse=c
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.class
set tabstop=2
set expandtab
set window=53
set nu
set fdm=marker
set statusline=%F%m%r%h%w\ [Type:\ %Y]\ [Lines:\ %L\ @\ %p%%\ {%l;%v}]
set laststatus=2
