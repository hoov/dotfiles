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

set cursorline

set hidden

set foldcolumn=0
set foldlevel=100
set number
set colorcolumn=120

set clipboard+=unnamedplus

set wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.pyc

if has('nvim-0.4')
  set wildoptions=pum
  set winblend=10
  set pumblend=10
endif

set scrolloff=3
set ignorecase
set smartcase

set spelllang=en_us

" Never want to use the mouse
set mouse=

nmap <leader>l :set list!<CR>
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:▸\ ,eol:¬,trail:·,extends:⟫,precedes:⟪,nbsp:␣

set undofile

function! s:SetExecutableBit()
  let l:fname = expand('%:p')
  checktime
  execute 'au FileChangedShell ' . l:fname . ' :echo'
  silent !chmod a+x %
  checktime
  execute 'au! FileChangedShell ' . l:fname
endfunction
command! Xbit call s:SetExecutableBit()

augroup vimrc
  autocmd!
  " Only highlight current lines when window has focus
  autocmd WinEnter,InsertLeave * set cursorline
  autocmd WinLeave,InsertEnter * set nocursorline
  autocmd FileType gitconfig,javascript,json,ruby,terraform,typescript,vim,yaml
        \ setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2

  " Reloads vimrc after saving but keep cursor position
  if !exists('*ReloadVimrc')
    function! ReloadVimrc() abort
      let save_cursor = getcurpos()
      source $MYVIMRC
      call setpos('.', save_cursor)
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
      call SaveTmuxline()
      redraw!
    endfunction
  endif

  let $VIM_CONFIG_HOME=expand('<sfile>:h')
  autocmd! BufWritePost $VIM_CONFIG_HOME/*.vim call ReloadVimrc()
augroup END

" Fish Shell
augroup filetype_fish
  autocmd!
  autocmd FileType fish compiler fish
  autocmd FileType fish setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 foldmethod=expr
augroup END

" Commit messages
augroup filetype_gitcommit
  autocmd!
  autocmd FileType gitcommit setlocal spell nofoldenable
augroup END

" Golang
augroup filetype_golang
  autocmd!
  autocmd FileType go setlocal shiftwidth=2 tabstop=2
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
  autocmd FileType python setlocal expandtab foldmethod=indent shiftwidth=4 softtabstop=4 tabstop=4 colorcolumn=80
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

" Typescript
augroup filetype_typescript
  autocmd!
  autocmd FileType typescript setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
  autocmd FileType typescriptreact setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END
