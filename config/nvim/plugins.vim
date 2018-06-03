"call plug#begin('~/.config/nvim/plugged')
"Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
"Plug 'docker/docker', { 'rtp': '/contrib/syntax/vim/' }
"Plug 'ternjs/tern_for_vim', { 'do': function('BuildTern') }

" Locally installed plugins
"Plug '/usr/local/opt/fzf'
"Plug 'junegunn/fzf.vim'

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

call minpac#add('airblade/vim-gitgutter')
call minpac#add('dag/vim-fish')
call minpac#add('jmcantrell/vim-virtualenv')
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('kchmck/vim-coffee-script')
call minpac#add('kshenoy/vim-signature')
call minpac#add('majutsushi/tagbar')
call minpac#add('rizzatti/dash.vim')
call minpac#add('rodjek/vim-puppet')
call minpac#add('scrooloose/nerdtree')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-rake')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-surround')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('w0rp/ale')
call minpac#add('yggdroot/indentline')

" Themes
call minpac#add('chriskempson/base16-vim')
packloadall
"
" Plugin configuration

" Valloric/YouCompleteMe
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" airblade/vim-gitgutter
nmap <leader>g :GitGutterLineHighlightsToggle<CR>

" jremmen/vim-ripgrep
map <Leader>r <Esc>:Rg<CR>
map <Leader>R <Esc>:Rg 
let g:rg_highlight = 1

" majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>

" rizzatti/dash.vim
nmap <silent> <leader>d <Plug>DashSearch

" scrooloose/nerdtree
if exists("NERDTree")
  nmap <leader>n :NERDTreeToggle<CR>
  nmap <leader>N :NERDTreeFind<CR>
  " If vim is opened without a file specified, open NERDTree
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
endif

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
silent! colorscheme base16-default-dark

" fzf
nnoremap <Leader>o :Files<CR>

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey

