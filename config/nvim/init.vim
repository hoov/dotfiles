scriptencoding utf-8

if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" Need to set leader before plugins
let g:mapleader=','

let $VIMPATH = fnamemodify(resolve(expand('<sfile>:p')), ':h')

if filereadable(expand('$VIMPATH/plugins.vim'))
  execute 'source' expand('$VIMPATH/plugins.vim')
endif

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

set cursorline

set hidden

set foldcolumn=4
set foldlevel=100
set number
set colorcolumn=120

set clipboard+=unnamedplus

set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.pyc

set scrolloff=3
set ignorecase
set smartcase

" Never want to use the mouse
set mouse=

nmap <leader>l :set list!<CR>
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:▸\ ,eol:¬,trail:·,extends:⟫,precedes:⟪,nbsp:␣

set undofile

function! SetExecutableBit()
  let l:fname = expand('%:p')
  checktime
  execute 'au FileChangedShell ' . l:fname . ' :echo'
  silent !chmod a+x %
  checktime
  execute 'au! FileChangedShell ' . l:fname
endfunction
command! Xbit call SetExecutableBit()

" netrw
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd StdinReadPre * let s:std_in=1
"   autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | :Vexplore | endif
" augroup END

" Filetypes

" General two space indent for certain filetypes
augroup vimrc
  autocmd!
  " Only highlight current lines when window has focus
  autocmd WinEnter,InsertLeave * set cursorline
  autocmd WinLeave,InsertEnter * set nocursorline
  autocmd FileType gitconfig,javascript,json,ruby,terraform,vim,yaml setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

" Fish Shell
augroup filetype_fish
  autocmd!
  autocmd FileType fish compiler fish
  autocmd FileTYpe fish setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 foldmethod=expr
augroup END

" Commit messages
augroup filetype_gitcommit
  autocmd!
  autocmd FileType gitcommit setlocal spell nofoldenable
augroup END

" JSON
augroup filetype_json
  autocmd!
  autocmd FileType json setlocal foldmethod=syntax
augroup END

" Python
augroup filetype_python
  autocmd!
  let g:python_highlight_all = 1
  autocmd FileType python setlocal expandtab foldmethod=indent shiftwidth=4 softtabstop=4 tabstop=4
augroup END

" Ruby
augroup filetype_ruby
  autocmd!
  autocmd FileType ruby compiler ruby
augroup END

" Terraform
augroup filetype_terraform
  autocmd!
  autocmd FileType terraform setlocal smartindent commentstring=#%s
augroup END
