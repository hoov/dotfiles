"call plug#begin('~/.config/nvim/plugged')
"Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
"Plug 'docker/docker', { 'rtp': '/contrib/syntax/vim/' }
"Plug 'ternjs/tern_for_vim', { 'do': function('BuildTern') }

" Locally installed plugins
"Plug '/usr/local/opt/fzf'
"Plug 'junegunn/fzf.vim'

" Themes
"Plug 'chriskempson/base16-vim'
"call plug#end()

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
