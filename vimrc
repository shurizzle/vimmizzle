set nocompatible
filetype off

set rtp+=~/.vim/plugged/vim-plug/
runtime plug.vim

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Plugins

Plug 'cocopon/iceberg.vim'
Plug 'git://git.wincent.com/command-t.git'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'

Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'noahfrederick/vim-composer'
Plug 'noahfrederick/vim-laravel'
Plug 'phpactor/phpactor' , {'do': 'composer install', 'for': 'php'}
Plug 'phpactor/ncm2-phpactor' , {'for': 'php'}

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'

call plug#end()

syntax enable
filetype plugin indent on

set encoding=utf-8

colo iceberg

set exrc
set secure
set viminfo+=!

set list listchars=tab:\ ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«

autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

map <S-n> :NERDTreeToggle<cr>

map t :tabnew<CR>
map <C-n> :tabn<CR>
map <C-p> :tabp<CR>

autocmd BufWritePre * :%s/\s\+$//e

set showcmd
set mouse=c
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.class
set shiftwidth=4
set tabstop=2
set expandtab
set window=53
set nu
set fdm=marker
set statusline=%F%m%r%h%w\ [Type:\ %Y]\ [Lines:\ %L\ @\ %p%%\ {%l;%v}]
set laststatus=2
