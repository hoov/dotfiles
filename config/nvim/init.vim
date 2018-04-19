if &shell =~# 'fish$'
    set shell=/bin/bash
endif

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

function! BuildTern(info)
  if a:info.status == 'installed' || a:info.force
    !npm install
  endif
endfunction

call plug#begin('~/.config/nvim/plugged')
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'airblade/vim-gitgutter'
Plug 'dag/vim-fish'
Plug 'jmcantrell/vim-virtualenv'
Plug 'kchmck/vim-coffee-script'
Plug 'kshenoy/vim-signature'
Plug 'majutsushi/tagbar'
Plug 'rodjek/vim-puppet'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'ternjs/tern_for_vim', { 'do': function('BuildTern') }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'yggdroot/indentline'

" Locally installed plugins
Plug '/usr/local/opt/fzf'

" Themes
Plug 'chriskempson/base16-vim'
call plug#end()

let mapleader=","

set cursorline

set hidden

set foldcolumn=4
set foldlevel=100
set number

set clipboard+=unnamedplus

set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.pyc

set scrolloff=3
"
" Never want to use the mouse
set mouse=

nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+

" Plugin configuration

" Valloric/YouCompleteMe
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" airblade/vim-gitgutter
nmap <leader>g :GitGutterLineHighlightsToggle<CR>

" majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>

" rking/ag.vim
map <Leader>a <Esc>:Ag!<CR>
map <Leader>A <Esc>:Ag!

" scrooloose/nerdtree
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>

" vim-airline/vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" w0rp/ale
let g:ale_open_list = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" chriskempson/base16-vim
let base16colorspace=256
set background=dark
colorscheme base16-default-dark

" fzf
nnoremap <Leader>o :FZF<CR>

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey

" Filetypes

" JSON
autocmd FileType json setlocal expandtab autoindent foldmethod=syntax shiftwidth=2 softtabstop=2

" Python
let python_highlight_all = 1
autocmd FileType python setlocal expandtab autoindent foldmethod=indent shiftwidth=4 softtabstop=4
