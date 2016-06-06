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

call plug#begin('~/.config/nvim/plugged')
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dag/vim-fish'
Plug 'majutsushi/tagbar'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Themes
Plug 'chriskempson/base16-vim'
call plug#end()

let mapleader=","

set cursorline

set hidden

set foldcolumn=4
set foldlevel=100
set number

set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.pyc

" Never want to use the mouse
set mouse=

nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬,trail:-,extends:>,precedes:<,nbsp:+

" Plugin configuration

" Valloric/YouCompleteMe
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" airblade/vim-gitgutter
nmap <leader>g :GitGutterLineHighlightsToggle<CR>

" ctrlpvim/ctrlp.vim
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPMRUFiles<CR>
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>

" rking/ag.vim
map <Leader>a <Esc>:Ag!<CR>
map <Leader>A <Esc>:Ag!

" scrooloose/nerdtree
nmap <leader>n :NERDTreeToggle<CR>

" scrooloose/syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

" vim-airline/vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
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

" chriskempson/base16-vim
let base16colorspace=256
set background=dark
colorscheme base16-solarized

" Filetypes

" Python
let python_highlight_all = 1
autocmd FileType python setlocal expandtab autoindent foldmethod=indent shiftwidth=4 softtabstop=4
