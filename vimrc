set nocompatible
filetype off

if has('win32') || has('win64')
  let g:vimhome = expand('~/_vim')
else
  let g:vimhome = expand('~/.vim')
endif

if isdirectory(g:vimhome)
  exe 'set rtp+='.fnameescape(g:vimhome)
endif

if isdirectory(g:vimhome.'/plugged/vim-plug')
  exe 'set rtp+='.fnameescape(g:vimhome.'/plugged/vim-plug')
  runtime plug.vim

  let g:plug_url_format = 'git@github.com:%s.git'

  call plug#begin(g:vimhome.'/plugged')

  Plug 'junegunn/vim-plug'

  " vim shims
  if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " Plugins
  Plug 'airblade/vim-rooter'
  Plug 'MarcWeber/vim-addon-local-vimrc'

  " Semantic language support
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
  if has('nvim-0.5')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  endif

  " ui
  if has('nvim')
    Plug 'glepnir/dashboard-nvim'
  endif
  Plug 'arcticicestudio/nord-vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-fugitive'
  Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
  Plug 'junegunn/goyo.vim'

  " lazyness
  Plug 'tpope/vim-repeat'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
  Plug 'neoclide/coc-pairs', {'do': 'yarn install --frozen-lockfile'}
  Plug 'editorconfig/editorconfig-vim'

  " Markdown
  Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown'}

  " viml
  Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}

  " web
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}

  " php
  if executable('php') && executable('composer')
    Plug 'phpactor/phpactor', {'for': 'php', 'branch': 'master', 'do': 'composer install --no-dev -o'}
    Plug 'marlonfan/coc-phpls', {'do': 'yarn install --frozen-lockfile'}
    Plug 'yaegassy/coc-php-cs-fixer', {'do': 'yarn install --frozen-lockfile'}
    Plug 'jwalton512/vim-blade'
    Plug 'yaegassy/coc-blade', {'do': 'yarn install --frozen-lockfile'}
  endif

  " typescript
  if !has('nvim-0.5')
    Plug 'HerringtonDarkholme/yats.vim'
  endif
  Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/coc-styled-components', {'do': 'yarn install --frozen-lockfile'}

  " deno
  Plug 'fannheyward/coc-deno'

  " rust
  if !has('nvim-0.5')
    Plug 'cespare/vim-toml'
    Plug 'rust-lang/rust.vim'
  endif
  Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}

  " nix
  if !has('nvim-0.5')
      Plug 'LnL7/vim-nix'
  endif

  " c
  Plug 'clangd/coc-clangd', {'do': 'yarn install --frozen-lockfile'}

  call plug#end()

  " vim-plug is managing itself as a plugin so disable PlugUpgrade
  delc PlugUpgrade
endif

" Reload vimrc if I'm working on it
au BufWritePost * if resolve($MYVIMRC) ==# resolve(expand('%:p')) | source % | endif

function! Colorschemes()
  let colors = split(globpath(&rtp, "colors/*.vim"), "\n")
  if has('packages')
    let colors += split(globpath(&packpath, "pack/*/opt/*/colors/*.vim"), "\n")
  endif

  return uniq(map(colors, "fnamemodify(v:val, ':t:r')"))
endfunction

function! HasColorscheme(name) abort
    let pat = 'colors/'.a:name.'.vim'
    return !empty(globpath(&rtp, pat)) || (has('packages') ? !empty(globpath(&packpath, 'pack/*/opt/*/'.pat)) : v:true)
endfunction

function! SetColorscheme(name) abort
  if type(a:name) == v:t_list
    for n in a:name
      if HasColorscheme(n)
        exe 'colo' n
        return
      endif
    endfor
  else
    if HasColorscheme(a:name)
      exe 'colo' a:name
    endif
  endif
endfunction

fu! ForceFunctionLoad(name)
  try
    exe 'call '.a:name.'()'
  catch
  endtry
endfu

fu! FunctionExists(name)
  call ForceFunctionLoad(a:name)
  return exists('*'.a:name)
endfu

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

call SetColorscheme(['nord', 'slate', 'evening'])

set noexrc
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
set nobackup
set nowritebackup
set noswapfile
set noundofile
set splitbelow
autocmd FileType php set iskeyword+=$

set list listchars=tab:\ ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«

let g:dashboard_default_executive ='fzf'
let g:dashboard_custom_header =<< END
           d8,                              d8,                 d8b
          `8P                              `8P                  88P
                                                               d88
?88   d8P  88b  88bd8b,d88b   88bd8b,d88b   88bd88888P d88888P 888   d8888b
d88  d8P'  88P  88P'`?8P'?8b  88P'`?8P'?8b  88P   d8P'    d8P' ?88  d8b_,dP
?8b ,88'  d88  d88  d88  88P d88  d88  88P d88  d8P'    d8P'    88b 88b
`?888P'  d88' d88' d88'  88bd88' d88'  88bd88' d88888P'd88888P'  88b`?888P'
END

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
  if get(g:, 'loaded_airline', 0)
    let spc = g:airline_symbols.space
    call airline#parts#define_raw('linenr', '%{g:airline_symbols.linenr}%l')
    call airline#parts#define_raw('maxlinenr', '/%L')
    call airline#parts#define_raw('colnr', ':%v')
    if airline#util#winwidth() > 79
      let g:airline_section_z = airline#section#create(['windowswap',
                  \ 'obsession', 'linenr', 'colnr', 'maxlinenr', spc.'%p%%'])
    else
      let g:airline_section_z = airline#section#create(['linenr', 'colnr',
                  \ spc.'%p%%'])
    endif

    call airline#update_statusline()
  endif
endfunction
autocmd VimEnter * call AirlineInit()

" rooter
let g:rooter_silent_chdir = 1
let g:rooter_manual_only = 1
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'Cargo.toml', 'composer.json']

" Coc
let g:coc_start_at_startup = 0
if FunctionExists('coc#config')
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
              \     'graphql',
              \     'c',
              \     'rust'
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
          \   'path': g:vimhome.'/plugged/phpactor/bin/phpactor'
          \ })

    call coc#config('php-cs-fixer', {
          \   'enableFormatProvider': v:true
          \ })
  endif

  " Coc rnix LSP
  if executable('rnix-lsp')
    call coc#config('languageserver.nix', {
      \   'command': 'rnix-lsp',
      \   'filetypes': ['nix'],
      \ })
  endif
endif

" explorer
let g:coc_explorer_global_presets = {
            \   '.vim': {
            \     'root-uri': g:vimhome,
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

aug stdin
  au!
  au StdinReadPre * let g:isReadingFromStdin = 1
aug END
let loaded_netrwPlugin = 1 " disable netrw
function! ProjectStart()
  " if user has passed a parameter and it's a directory just use it has the
  " project folder, else use vim-rooter
  if argc() ==# 1 && isdirectory(argv(0))
    execute 'cd' fnameescape(argv(0))
    bdelete
    let l:has_root = v:true
    let l:has_params = v:false
  else
    let l:has_params = !!argc()
    if get(g:, 'loaded_rooter', 0)
      let l:has_root = !empty(FindRootDirectory()) " check if it is a project

      Rooter " start rooter
    else
      let l:has_root = v:false
    endif
  endif

  if get(g:, 'did_coc_loaded', 0)
    call coc#rpc#start_server() " start coc

    " open coc-explorer if I'm in a project and vim is opened without arguments
    " or only a directory and stdin is not a pipe
    if l:has_root && !l:has_params && !exists('g:isReadingFromStdin') " if is project
      CocCommand explorer --preset floatingLeftside
    endif
  endif
endfunction
au VimEnter * call ProjectStart()

if FunctionExists('fzf#vim#files')
  command! -bang -nargs=? -complete=dir F call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
endif

fu! s:on_coc_load()
  if get(g:, 'did_coc_loaded', 0)
    nnoremap <silent> <space>e :CocCommand explorer<CR>
    nnoremap <silent> <space>ef :CocCommand explorer --preset floating<CR>
    nnoremap <silent> <space>et :CocCommand explorer --preset tab<CR>

    " Select range based on AST
    nmap <silent><Leader>r <Plug>(coc-range-select)
    xmap <silent><Leader>r <Plug>(coc-range-select)

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

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

    " Use <CR> to validate completion (allows auto import on completion)
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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
    aug highlight
      au!
      au CursorHold * silent call CocActionAsync('highlight')
    aug END

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')
  endif
endfu
autocmd VimEnter * call s:on_coc_load()

aug explorer
  au!
  au BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
aug END

map <C-n> :tabn<CR>
map <C-p> :tabp<CR>

aug removetrailingspaces
  au!
  au BufWritePre * :%s/\s\+$//e
aug END

" rust
let g:rustfmt_autosave = 0
let g:rustfmt_fail_silently = 0

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" Paste replace visual selection without copying it
vnoremap <leader>p "_dP

" Make Y behave like the other capitals
nnoremap Y y$

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

if executable('curl')
  " Generic upload service
  function! PasteService(name, cmd, line1, line2) abort
    let l:text = join(getline(a:line1, a:line2), "\n")
    redraw | echon 'Posting to ' . a:name . '... '

    let l:url = system(a:cmd, l:text)[0:-2]
    redraw
    if empty(l:url)
      let l:url = system("curl -s http://google.com")
      if empty(l:url)
        echohl WarningMsg|echomsg 'Error: no network available'
      else
        echohl WarningMsg|echomsg 'Error: ' . a:name . ' has been shutdown or altered its api'
      endif
      echohl None
    else
      call setreg('+', l:url)
      echomsg 'Done: ' . l:url
    endif
  endfunction

  " sprunge command
  command! -range=% -nargs=0 Sprunge call PasteService('sprunge.us', 'curl -s -F "sprunge=<-" http://sprunge.us', <line1>, <line2>)

  " paste command
  command! -range=% -nargs=0 Paste call PasteService('paste.rs', 'curl -s --data-binary @- https://paste.rs', <line1>, <line2>)
endif

syntax on
filetype plugin indent on
if has('nvim-0.5')
  fu! s:on_treesitter_load()
    if get(g:, 'loaded_nvim_treesitter', 0)
      lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'rust', 'php', 'html', 'css', 'scss', 'json', 'jsonc', 'toml',
    'javascript', 'typescript', 'tsx', 'vim', 'yaml', 'lua', 'nix', 'comment',
    'regex', 'dockerfile', 'bash'
  },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}
EOF

      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
    endif
  endfu
  autocmd VimEnter * call s:on_treesitter_load()
endif

if has('nvim-0.5')
  function! Cargo(args) abort
      let args = substitute(a:args, '\s\+$', '', '')
      if has('terminal')
        let cmd = 'terminal'
      elseif has('nvim')
        let cmd = 'noautocmd new | terminal'
      else
        let cmd = '!'
      endif
      echo cmd

      execute cmd 'cargo' args
  endfunction

  command! -nargs=+ Cargo call Cargo(<q-args>)
endif

" vim:set ft=vim sw=2 sts=2 et:
