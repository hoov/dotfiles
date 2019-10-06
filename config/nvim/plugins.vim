"Plug 'docker/docker', { 'rtp': '/contrib/syntax/vim/' }
"Plug 'ternjs/tern_for_vim', { 'do': function('BuildTern') }

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('airblade/vim-gitgutter')
call minpac#add('chr4/nginx.vim')
" This is super old, but the one most commonly used
call minpac#add('dag/vim-fish')
call minpac#add('hashivim/vim-terraform')
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('kchmck/vim-coffee-script')
call minpac#add('kshenoy/vim-signature')
call minpac#add('majutsushi/tagbar')
call minpac#add('rodjek/vim-puppet')
call minpac#add('rust-lang/rust.vim')
call minpac#add('saltstack/salt-vim')
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

" Autocomplete
call minpac#add('ncm2/ncm2')
call minpac#add('roxma/nvim-yarp')

" Autocomplete plugins
call minpac#add('ncm2/ncm2-bufword')
call minpac#add('ncm2/ncm2-jedi')
call minpac#add('ncm2/ncm2-path')
call minpac#add('ncm2/ncm2-vim')
call minpac#add('Shougo/neco-vim')

" Themes
call minpac#add('chriskempson/base16-vim')

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" Plugin configuration

" airblade/vim-gitgutter
nmap <leader>g :GitGutterLineHighlightsToggle<CR>

" hashivim/vim-terraform
let g:terraform_fmt_on_save=1

" jremmen/vim-ripgrep
map <Leader>r <Esc>:Rg<CR>
map <Leader>R <Esc>:Rg 
let g:rg_highlight = 1

" junegunn/fzf
nnoremap <Leader>o :Files<CR>

" majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>

" scrooloose/nerdtree
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>N :NERDTreeFind<CR>
" If vim is opened without a file specified, open NERDTree
augroup nerdtree_stdin
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup END

" vim-airline/vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#enabled = 1
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

" vim-airline/vim-airline-themes
let g:airline_theme='base16_vim'
let g:airline_base16_solarized=1

" w0rp/ale
let g:ale_open_list = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_linters = { 'javascript': ['standard'], }

" yggdroot/indentline
let g:indentLine_char = '¦'

" Autocomplete configuration

" ncm2/ncm2
augroup ncm_setup
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
  set completeopt=noinsert,menuone,noselect
augroup END

" Theme configuration

" chriskempson/base16-vim
function! s:base16_customize() abort
  " Add the same fancy things that the solarized theme from the actual author
  " does
  call Base16hi("Italic", "", "", "", "", "italic", "")
  call Base16hi("Comment", g:base16_gui03, "", g:base16_cterm03, "", "italic", "")
  call Base16hi("gitcommitComment", g:base16_gui03, "", g:base16_cterm03, "", "italic", "")
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  set background=dark
  source ~/.vimrc_background
endif
