if &shell =~# 'fish$'
    set shell=/bin/bash
endif

call plug#begin("~/.config/nvim/plugged")
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Themes
Plug 'nanotech/jellybeans.vim'
call plug#end()

colorscheme jellybeans
let mapleader=","

set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.pyc

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Plugin configuration

" ctrlpvim/ctrlp.vim
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPMRUFiles<CR>

" scrooloose/nerdtree
nmap <leader>n :NERDTreeToggle<CR>

" scrooloose/syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-airline/vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
