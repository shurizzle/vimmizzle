set nocompatible
filetype off

set rtp+=~/.vim/plugged/vim-plug/
runtime plug.vim

let g:plug_url_format = 'git@github.com:%s.git'

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-plug'

" vim shims
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Plugins

Plug 'airblade/vim-rooter'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}

" ui
Plug 'cocopon/iceberg.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}

" lazyness
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc-pairs', {'do': 'yarn install --frozen-lockfile'}

" viml
Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}

" web
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}

" php
if executable('php') && executable('composer')
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-projectionist'
  Plug 'noahfrederick/vim-composer'
  Plug 'noahfrederick/vim-laravel'
  Plug 'phpactor/phpactor', {'do': 'composer install', 'for': 'php'}
  Plug 'phpactor/coc-phpactor', {'do': 'yarn install --frozen-lockfile'}
  Plug 'yaegassy/coc-php-cs-fixer', {'do': 'yarn install --frozen-lockfile'}
  Plug 'jwalton512/vim-blade'
  Plug 'yaegassy/coc-blade-linter', {'do': 'yarn install --frozen-lockfile'}
  "Plug 'yaegassy/coc-blade-formatter', {'do': 'yarn install --frozen-lockfile'}
endif

" typescript
Plug 'HerringtonDarkholme/yats.vim', {'for': 'typescript'}
Plug 'mhartington/nvim-typescript', {'do': './install.sh', 'for': 'typescript'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}

" rust
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'
Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}

call plug#end()

" vim-plug is managing itself as a plugin so disable PlugUpgrade
delc PlugUpgrade

" Reload vimrc when working on it
au! BufWritePost $MYVIMRC source %

function! HasColorscheme(name) abort
    let pat = 'colors/'.a:name.'.vim'
    return !empty(globpath(&rtp, pat))
endfunction

syntax enable
filetype plugin indent on

let mapleader = ","

set encoding=utf-8
if has('termguicolors')
  set termguicolors
endif
set t_ut=
if $TERM ==# 'xterm-kitty'
  set t_Co=256
  if !has('nvim')
    set t_8f=[38:2:%lu:%lu:%lum
    set t_8b=[48:2:%lu:%lu:%lum
  endif
endif

if HasColorscheme('iceberg')
  colo iceberg
endif

set exrc
set secure
set viminfo+=!
set clipboard+=unnamedplus
set showcmd
set noshowmode
set mouse=a
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.class
set shiftwidth=4
set tabstop=2
set expandtab
set window=53
set colorcolumn=80
set background=dark
set nu rnu
set fdm=marker
set laststatus=2

set list listchars=tab:\ ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
function! AirlineInit()
  let spc = g:airline_symbols.space
  call airline#parts#define('linenr', {
              \   'raw': '%{g:airline_symbols.linenr}%l',
              \   'accent': 'normal'
              \ })
  call airline#parts#define('maxlinenr', {
              \   'raw': '/%L',
              \   'accent': 'normal'
              \ })
  call airline#parts#define('colnr', {
              \   'raw': ':%v',
              \   'accent': 'normal'
              \ })
  if airline#util#winwidth() > 79
    let g:airline_section_z = airline#section#create(['windowswap',
                \ 'obsession', 'linenr', 'colnr', 'maxlinenr', spc.'%p%%'])
  else
    let g:airline_section_z = airline#section#create(['linenr', 'colnr',
                \ spc.'%p%%'])
  endif

  call airline#update_statusline()
endfunction
autocmd VimEnter * call AirlineInit()

" rooter
let g:rooter_silent_chdir = 1
let g:rooter_manual_only = 1

" Coc
let g:coc_start_at_startup = 0
if !empty(glob('~/.vim/plugged/coc.nvim'))
  call coc#config('suggest', {'noselect': v:false})
  call coc#config('coc', {
              \   'preferences.formatOnSaveFiletypes': [
              \     'javascript',
              \     'typescript',
              \     'typescriptreact',
              \     'json',
              \     'php',
              \     'blade',
              \     'typescript.tsx',
              \     'graphql'
              \   ]
              \ })

  " Explorer
  call coc#config('explorer', {
              \   'previewAction.onHover': v:false,
              \   'keyMappings.global': {
              \     '<cr>': ['expandable?', ['expanded?', 'collapse','expand'], 'open'],
              \     'v': 'open:vsplit'
              \   }
              \ })
  " PHP
  if executable('php') && executable('composer')
    call coc#config('phpactor', {
          \   'enable': v:true,
          \   'path': '~/.vim/plugged/phpactor/bin/phpactor'
          \ })

    call coc#config('php-cs-fixer', {
          \   'enableFormatProvider': v:true
          \ })
  endif
endif

" explorer
let g:coc_explorer_global_presets = {
            \   '.vim': {
            \     'root-uri': '~/.vim',
            \   },
            \   'tab': {
            \     'position': 'tab',
            \     'quit-on-open': v:true,
            \   },
            \   'floating': {
            \     'position': 'floating',
            \     'open-action-strategy': 'sourceWindow',
            \   },
            \   'floatingTop': {
            \     'position': 'floating',
            \     'floating-position': 'center-top',
            \     'open-action-strategy': 'sourceWindow',
            \   },
            \   'floatingLeftside': {
            \     'position': 'floating',
            \     'floating-position': 'left-center',
            \     'floating-width': 50,
            \     'open-action-strategy': 'sourceWindow',
            \   },
            \   'floatingRightside': {
            \     'position': 'floating',
            \     'floating-position': 'right-center',
            \     'floating-width': 50,
            \     'open-action-strategy': 'sourceWindow',
            \   },
            \   'simplify': {
            \     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
            \   }
            \ }

autocmd StdinReadPre * let g:isReadingFromStdin = 1
function! ProjectStart()
  let has_root = !empty(FindRootDirectory()) " check if it is a project

  Rooter " start rooter
  call coc#rpc#start_server() " start coc

  " open coc-explorer if I'm in a project and vim is opened without arguments
  " nor a stdin pipe
  if has_root && !argc() && !exists('g:isReadingFromStdin') " if is project
    call coc#rpc#notify('runCommand', ['explorer'])
  endif
endfunction
autocmd VimEnter * call ProjectStart()

nnoremap <silent> <space>e :CocCommand explorer<CR>
nnoremap <silent> <space>ef :CocCommand explorer --preset floating<CR>
nnoremap <silent> <space>et :CocCommand explorer --preset tab<CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

map t :tabnew<CR>
map <C-n> :tabn<CR>
map <C-p> :tabp<CR>

autocmd BufWritePre * :%s/\s\+$//e

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" Select range based on AST
nmap <silent><Leader>r <Plug>(coc-range-select)
xmap <silent><Leader>r <Plug>(coc-range-select)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Navigations
nmap <silent> tgd :<C-u>call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> tgy :<C-u>call CocAction('jumpTypeDefinition', 'tab drop')<CR>
nmap <silent> tgi :<C-u>call CocAction('jumpImplementation', 'tab drop')<CR>
nmap <silent> tgr :<C-u>call CocAction('jumpReferences', 'tab drop')<CR>
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

" Execute macro on each line if in visual mode
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" just use vim.
nnoremap <Left> :echo "No left for you!"<CR>
vnoremap <Left> :<C-u>echo "No left for you!"<CR>
inoremap <Left> <C-o>:echo "No left for you!"<CR>
nnoremap <Right> :echo "No right for you!"<CR>
vnoremap <Right> :<C-u>echo "No right for you!"<CR>
inoremap <Right> <C-o>:echo "No right for you!"<CR>
nnoremap <Up> :echo "No up for you!"<CR>
vnoremap <Up> :<C-u>echo "No up for you!"<CR>
inoremap <Up> <C-o>:echo "No up for you!"<CR>
nnoremap <Down> :echo "No down for you!"<CR>
vnoremap <Down> :<C-u>echo "No down for you!"<CR>
inoremap <Down> <C-o>:echo "No down for you!"<CR>
nnoremap <PageUp> :echo "No page up for you!"<CR>
vnoremap <PageUp> :<C-u>echo "No page up for you!"<CR>
inoremap <PageUp> <C-o>:echo "No page up for you!"<CR>
nnoremap <PageDown> :echo "No page down for you!"<CR>
vnoremap <PageDown> :<C-u>echo "No page down for you!"<CR>
inoremap <PageDown> <C-o>:echo "No page down for you!"<CR>
nnoremap <End> :echo "No end for you!"<CR>
vnoremap <End> :<C-u>echo "No end for you!"<CR>
inoremap <End> <C-o>:echo "No end for you!"<CR>
nnoremap <Home> :echo "No home for you!"<CR>
vnoremap <Home> :<C-u>echo "No home for you!"<CR>
inoremap <Home> <C-o>:echo "No home for you!"<CR>

" sprunge command
function! Sprunge(line1, line2) abort
  let l:text = join(getline(a:line1, a:line2), "\n")
  redraw | echon 'Posting to sprunge ... '

  let l:url = system('curl -s -F "sprunge=<-" http://sprunge.us', l:text)[0:-2]
  redraw
  if empty(l:url)
    let l:url = system("curl -s http://google.com")
    if empty(l:url)
      echohl WarningMsg|echomsg 'Error: no network available'
    else
      echohl WarningMsg|echomsg 'Error: sprunge.us has been shutdown or altered its api'
    endif
    echohl None
  else
    call setreg('+', l:url)
    echomsg 'Done: ' . l:url
  endif
endfunction
command! -range=% -nargs=0 Sprunge call Sprunge(<line1>, <line2>)

" vim:set ft=vim sw=2 sts=2 et:
