set nocompatible
filetype off

set rtp+=~/.vim/plugged/vim-plug/
runtime plug.vim

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

" vim shims
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Plugins

Plug 'cocopon/iceberg.vim'
Plug 'git://git.wincent.com/command-t.git'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
endif
let g:deoplete#enable_at_startup = 1

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'noahfrederick/vim-composer'
Plug 'noahfrederick/vim-laravel'
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs', 'for': 'php'}
Plug 'phpactor/phpactor' , {'do': 'composer install', 'for': 'php'}
Plug 'phpactor/ncm2-phpactor' , {'for': 'php'}

" typescript
Plug 'HerringtonDarkholme/yats.vim' , {'for': 'typescript'}
Plug 'mhartington/nvim-typescript', {'do': './install.sh', 'for': 'typescript'}

" rust
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'autozimu/LanguageClient-neovim', {
\ 'branch': 'next',
\ 'do': 'bash install.sh',
\ }

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
set mouse=a
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.class
set shiftwidth=4
set tabstop=2
set expandtab
set window=53
set nu
set fdm=marker
set statusline=%F%m%r%h%w\ [Type:\ %Y]\ [Lines:\ %L\ @\ %p%%\ {%l;%v}]
set laststatus=2

let g:LanguageClient_serverCommands = {
\ 'rust': ['rust-analyzer'],
\ }
