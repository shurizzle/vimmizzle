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

Plug 'airblade/vim-rooter'

" ui
Plug 'cocopon/iceberg.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" lazyness
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" :CocInstall coc-phpactor
" :CocInstall coc-rust-analyzer

" php
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'noahfrederick/vim-composer'
Plug 'noahfrederick/vim-laravel'
Plug 'phpactor/phpactor' , {'do': 'composer install', 'for': 'php'}

" typescript
Plug 'HerringtonDarkholme/yats.vim' , {'for': 'typescript'}
Plug 'mhartington/nvim-typescript', {'do': './install.sh', 'for': 'typescript'}

" rust
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'

call plug#end()

syntax enable
filetype plugin indent on

let mapleader = ","

set encoding=utf-8

colo iceberg

set exrc
set secure
set viminfo+=!
set clipboard+=unnamedplus

set list listchars=tab:\ ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«

map <C-b> :NERDTreeToggle<cr>

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
set nu rnu
set fdm=marker
set statusline=%F%m%r%h%w\ [Type:\ %Y]\ [Lines:\ %L\ @\ %p%%\ {%l;%v}]
set laststatus=2

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" Select range based on AST
nmap <silent><Leader>r <Plug>(coc-range-select)
xmap <silent><Leader>r <Plug>(coc-range-select)

" Navigations
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" List code actions available for the current buffer
nmap <leader>a  <Plug>(coc-codeaction)

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <CR> to validate completion (allows auto import on completion)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Hover
nmap K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Text objects for functions and classes (uses document symbol provider)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
autocmd CursorHold * silent call CocActionAsync('highlight')

" just use vim.
nnoremap <Left> :echo "No left for you!"<CR>
vnoremap <Left> :<C-u>echo "No left for you!"<CR>
inoremap <Left> <C-o>echo "No left for you!"<CR>
nnoremap <Right> :echo "No right for you!"<CR>
vnoremap <Right> :<C-u>echo "No right for you!"<CR>
inoremap <Right> <C-o>echo "No right for you!"<CR>
nnoremap <Up> :echo "No up for you!"<CR>
vnoremap <Up> :<C-u>echo "No up for you!"<CR>
inoremap <Up> <C-o>echo "No up for you!"<CR>
nnoremap <Down> :echo "No down for you!"<CR>
vnoremap <Down> :<C-u>echo "No down for you!"<CR>
inoremap <Down> <C-o>echo "No down for you!"<CR>
nnoremap <PageUp> :echo "No page up for you!"<CR>
vnoremap <PageUp> :<C-u>echo "No page up for you!"<CR>
inoremap <PageUp> <C-o>echo "No page up for you!"<CR>
nnoremap <PageDown> :echo "No page down for you!"<CR>
vnoremap <PageDown> :<C-u>echo "No page down for you!"<CR>
inoremap <PageDown> <C-o>echo "No page down for you!"<CR>
nnoremap <End> :echo "No end for you!"<CR>
vnoremap <End> :<C-u>echo "No end for you!"<CR>
inoremap <End> <C-o>echo "No end for you!"<CR>
nnoremap <Home> :echo "No home for you!"<CR>
vnoremap <Home> :<C-u>echo "No home for you!"<CR>
inoremap <Home> <C-o>echo "No home for you!"<CR>
