scriptencoding utf-8

packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('cespare/vim-toml')
call minpac#add('chr4/nginx.vim')
call minpac#add('dag/vim-fish') " This is super old, but the one most commonly used
call minpac#add('dense-analysis/ale')
call minpac#add('elzr/vim-json')
call minpac#add('gisphm/vim-gitignore')
call minpac#add('fatih/vim-go', {'do': ':GoUpdateBinaries'})
call minpac#add('hashivim/vim-terraform')
call minpac#add('hashivim/vim-vagrant')
call minpac#add('HerringtonDarkholme/yats.vim')
"call minpac#add('honza/vim-snippets')
call minpac#add('itchyny/lightline.vim')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('junegunn/goyo.vim')
call minpac#add('kchmck/vim-coffee-script')
call minpac#add('kshenoy/vim-signature')
call minpac#add('liuchengxu/vista.vim')
call minpac#add('majutsushi/tagbar')
call minpac#add('mcchrish/extend-highlight.vim') " This is one I can/should write better: synIDattr(synIDtrans(hlID(...
call minpac#add('mengelbrecht/lightline-bufferline')
call minpac#add('neoclide/jsonc.vim')
call minpac#add('raimon49/requirements.txt.vim')
call minpac#add('rodjek/vim-puppet')
call minpac#add('rust-lang/rust.vim')
call minpac#add('ryanoasis/vim-devicons')
call minpac#add('sainnhe/artify.vim')
call minpac#add('saltstack/salt-vim')
call minpac#add('scrooloose/nerdtree')
call minpac#add('tmux-plugins/vim-tmux')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-rake')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-scriptease')
call minpac#add('tpope/vim-surround')
call minpac#add('yggdroot/indentline')

"  my forks
call minpac#add('hoov/tmuxline.vim', {'branch': 'truecolor-lightline'})


" Autocomplete plugins

" Use tslint until eslint has all the features
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-eslint',
      \ 'coc-git',
      \ 'coc-go',
      \ 'coc-highlight',
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-python',
      \ 'coc-rls',
      \ 'coc-snippets',
      \ 'coc-syntax',
      \ 'coc-tsserver',
      \ 'coc-vimlsp'
      \ ]

" When we need to debug coc
" let $NVIM_COC_LOG_LEVEL = 'debug'
" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']

call minpac#add('neoclide/coc.nvim', {'branch': 'release'})

" Themes
" The official one is morhetz/gruvbox, but it's busted in a bunch of cases.
" This fork seems to be a little better
call minpac#add('gruvbox-community/gruvbox')

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" Plugin configuration

" dense-analysis/ale
let g:ale_open_list = 0
" TODO: Combine this with Coc diagnostics somehow
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Disable certain linters that coc takes care of
let g:ale_linters = { 'javascript': ['standard'],
                    \ 'rust': [],
                    \ 'python': [],
                    \ 'sh': [],
                    \ 'typescript': [],
                    \ 'vim': []}
let g:ale_sh_language_server_use_global = 1

let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'

" edkolev/tmuxline.vim
let g:tmuxline_preset = {
      \ 'a': '  #S',
      \ 'win': [ '#I', '#W'],
      \ 'cwin': [ '#I', '#W', '#F'],
      \ 'x': [ '#{sysstat_cpu} #{cpu.color}#{cpu.pused}', '  #{cpu_fg_color}#{cpu_percentage} #{cpu_icon}' ],
      \ 'y': [ ' ', '%a', '%b %e %I:%M %p' ],
      \ 'z': ['  ', '#{public_ip}', '#H']
      \ }
let g:tmuxline_separators = {
      \ 'left': '',
      \ 'left_alt': ' ',
      \ 'right': '',
      \ 'right_alt': ' ',
      \ 'space': ' '
      \ }

function! SaveTmuxline() abort
  if !strlen($TMUX) || !executable('tmux')
    return
  endif

  Tmuxline lightline
  TmuxlineSnapshot! ~/.tmux/gruvbox.conf
  silent execute '!tmux source-file ~/.tmux.conf'
	silent execute '!tmux display-message "Sourced .tmux.conf"'
endfunction

nnoremap <silent> <leader>T :call SaveTmuxline()<CR>

" fatih/vim-go
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" hashivim/vim-terraform
let g:terraform_fmt_on_save=1

" itchyny/lightline.vim
set showtabline=2

function! Devicons_Fileformat() abort
    return winwidth(0) > 70 ? (WebDevIconsGetFileFormatSymbol().'  '.&fileencoding.'['.&fileformat.']' ) : ''
endfunction"

" Ideas for status glyphs
"                  
" TODO: I think I want to break this out into seperate functions so that I can
" highlight different sections in the lightline, but I need to figure out how
" to cache the info so we don't do all this nonesence too often

function! s:UpdateDiagnosticStatus() abort
  let l:coc_info = get(b:, 'coc_diagnostic_info', {})
  let l:ale_info = {}

  if get(g:, 'ale_enabled', 1)
    let l:ale_info = ale#statusline#Count(bufnr(''))
  endif

  if empty(l:coc_info) && empty(l:ale_info)
    let b:diagnostic_info = {}
  endif

  let l:diagnostic_info = {}

  " Taking the levels from coc and smooshing in ALE to fit
  let l:diagnostic_info.error = get(l:coc_info, 'error', 0) + get(l:ale_info, 'error', 0)
  let l:diagnostic_info.warning = get(l:coc_info, 'warning', 0) 
        \ + get(l:ale_info, 'warn', 0)
        \ + get(l:ale_info, 'style_error', 0)
        \ + get(l:ale_info, 'style_warning', 0)
  let l:diagnostic_info.info = get(l:coc_info, 'information', 0) + get(l:ale_info, 'info', 0)
  let l:diagnostic_info.hint = get(l:coc_info, 'hint', 0)

  let b:diagnostic_info = l:diagnostic_info

  call lightline#update()
endfunction

function! s:FormatDiagnosticInfo(kind)
  let l:symbols = {
        \ 'error': ' ',
        \ 'warning': ' ',
        \ 'info': ' ',
        \ 'hint': ' ',
        \ }

  let l:diagnostic_info = get(b:, 'diagnostic_info', {})

  if empty(l:diagnostic_info)
    return ''
  endif

  let l:num = get(l:diagnostic_info, a:kind, 0)

  if l:num == 0
    return ''
  endif

  return get(l:symbols, a:kind) . ' ' . l:num
endfunction

function! LightlineErrorCount() abort
  return s:FormatDiagnosticInfo('error')
endfunction

function! LightlineWarningCount() abort
  return s:FormatDiagnosticInfo('warning')
endfunction

function! LightlineInfoCount() abort
  return s:FormatDiagnosticInfo('info')
endfunction

function! LightlineHintCount() abort
  return s:FormatDiagnosticInfo('hint')
endfunction

function! CocGitStatus() abort
  return get(b:, 'coc_git_status', '')
endfunction

function! CocStatus() abort
  return get(g:, 'coc_status', '')
endfunction

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

let g:lightline = {}
let g:lightline.colorscheme='gruvbox'
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': ' ', 'right': ' ' }

" coc_status and filetype are in the *wrong* order, but they render in the
" order that I want them. No clue what's going on.
let g:lightline.active = {
      \ 'left': [['artify_mode', 'paste'],
      \          ['readonly', 'filename', 'modified'],
      \          ['devicons_fileformat', 'method']],
      \ 'right': [['lineinfo'],
      \           ['percent'],
      \           ['coc_status', 'filetype', 'error_count', 'warning_count', 'info_count', 'hint_count']]
      \ }
let g:lightline.inactive = {
      \ 'left': [['filename']],
      \ 'right': [['lineinfo'], ['percent']]
      \ }

let g:lightline.tabline_separator = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator = { 'left': ' ', 'right': ' ' }
let g:lightline.tabline = {
      \ 'left': [ [ 'vim_logo', 'buffers' ] ],
      \ 'right': [ [ 'artify_gitbranch' ],
      \ [ 'coc_git_status' ] ]
      \ }
" Expansions
let g:lightline.component = {
      \ 'lineinfo': ' %3l:%-2v',
      \ 'percent': '%3p%%',
      \ 'vim_logo': ' '
      \ }
let g:lightline.component_function = {
      \ 'artify_gitbranch': 'Artify_gitbranch',
      \ 'artify_mode': 'Artify_lightline_mode',
      \ 'coc_git_status': 'CocGitStatus',
      \ 'devicons_fileformat': 'Devicons_Fileformat',
      \ 'diagnostic_status': 'DiagnosticStatus',
      \ 'method': 'NearestMethodOrFunction'
      \ }
let g:lightline.component_expand = {
      \ 'buffers': 'lightline#bufferline#buffers',
      \ 'coc_status': 'CocStatus',
      \ 'error_count': 'LightlineErrorCount',
      \ 'warning_count': 'LightlineWarningCount',
      \ 'info_count': 'LightlineInfoCount',
      \ 'hint_count': 'LightlineHintCount'
      \ }
let g:lightline.component_type = {
      \ 'buffers':  'tabsel',
      \ 'error_count': 'error',
      \ 'warning_count': 'warning'
      \ }

" junegunn/fzf

let g:fzf_buffers_jump = 1
let g:fzf_command_prefix = 'Fzf'

nnoremap <Leader>b :FzfBuffers<CR>
nnoremap <Leader>o :FzfGitFiles<CR>
nnoremap <Leader>O :FzfFiles<CR>
nnoremap <Leader>r :FzfRg<CR>
nnoremap <Leader>R :FzfRg <C-R><C-W><CR>
nnoremap <Leader>T :FzfTags<CR>

" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--layout=reverse --border'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)

  " 50% of the height
  let height = float2nr(&lines * 0.5)
  " 60% of the height
  let width = float2nr(&columns * 0.6)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  " Tried setting colors here with nvim_win_set_option, but fzf overrides it.
  " See the autocmd down at the bottom.
  return nvim_open_win(buf, v:true, opts)
endfunction

" liuchengxu/vista.vim
nnoremap <Leader>v :Vista!!<CR>
let g:vista#renderer#enable_icon = 1
let g:vista_fzf_preview = ['right:50%']
let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
let g:vista_sidebar_width = 50
let g:vista_stay_on_open = 0

augroup vista_custom
  autocmd!
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
augroup END

" majutsushi/tagbar
nnoremap <F8> :TagbarToggle<CR>

" mengelbrecht/lightline-bufferline
let g:lightline#bufferline#enable_devicons = v:true
let g:lightline#bufferline#unicode_symbols = v:true
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#filename_modifier = ':~:.'

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" rust-lang/rust.vim
let g:rustfmt_autosave = 1
let g:rustfmt_emit = 1

" ryanoasis/vim-devicons
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let g:DevIconsEnableFoldersOpenClose = v:true


" sainnhe/artify.vim
function! Artify_lightline_mode() abort
    return lightline#mode()
endfunction

function! Artify_gitbranch() abort
  if FugitiveHead() !=# ''
    return FugitiveHead().'  '
  else
    return "\ue61b "
  endif
endfunction

" scrooloose/nerdtree
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 0

" This comes from https://github.com/scrooloose/nerdtree/issues/904. It'll
" make arrows invisible since we're using devicons anyway
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
let g:NERDTreeNodeDelimiter = "\u263a" " smiley face -- character doesn't matter

nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>N :NERDTreeFind<CR>

function! s:CloseIfOnlyWindow() abort
  if winnr('$') != 1
    return
  endif

  if ((exists('b:NERDTree') && b:NERDTree.isTabTree()) || &buftype ==# 'quickfix')
    quit
  endif
endfunction


" If vim is opened without a file specified, open NERDTree
augroup nerdtree_custom
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  autocmd BufEnter * call s:CloseIfOnlyWindow()
augroup END

" yggdroot/indentline
let g:indentLine_char = '¦'
" This plugin might be more trouble than it's worth. This makes json behave
" sanely
let g:indentLine_concealcursor=''

" Autocomplete configuration

" neoclide/coc.nvim
augroup coc_setup
  autocmd!

  set cmdheight=2
  set shortmess+=c

  if has('nvim-0.4')
    set signcolumn=auto:3
  else
    set signcolumn=yes
  end

  set updatetime=300

  autocmd User ALEJobStarted,AELintPost,ALEFixPost call s:UpdateDiagnosticStatus()
  autocmd User CocStatusChange,CocDiagnosticChange call s:UpdateDiagnosticStatus()
  autocmd User CocGitStatusChange call lightline#update()

  let g:coc_enable_locationlist=1
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>""

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gl <Plug>(coc-codelens-action)

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync("highlight")
  
  " Create mappings for function text object, requires document symbols feature of languageserver.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
augroup END

" Theme configuration

" gruvbox-community/gruvbox
set background=dark
if has('termguicolors')
  set termguicolors
endif

let g:gruvbox_italic=1

function! s:gruvbox_customize() abort
  let g:fzf_colors = {
        \ 'fg': ['fg', 'Pmenu'],
        \ 'bg': ['bg', 'Pmenu'],
        \ 'hl': ['fg', 'GruvboxYellow'],
        \ 'fg+': ['fg', 'GruvboxFg1'],
        \ 'bg+': ['bg', 'Pmenu'],
        \ 'hl+': ['fg', 'GruvboxYellow'],
        \ 'info': ['fg', 'GruvboxBlue'],
        \ 'prompt': ['fg', 'GruvboxFg4'],
        \ 'pointer': ['fg', 'GruvboxBlue'],
        \ 'marker': ['fg', 'GruvboxOrange'],
        \ 'spinner': ['fg', 'GruvboxYellow'],
        \ 'header': ['fg', 'GruvboxBg3']
        \ }

  if has('nvim-0.4')
    highlight! PmenuSel blend=0
  endif

  highlight! CocUnderline cterm=undercurl gui=undercurl
  highlight! link CocErrorSign ALEErrorSign
  highlight! link CocWarningSign ALEWarningSign
  highlight! link CocInfoSign ALEInfoSign
  highlight! link CocHintSign GruvboxPurpleSign

  highlight! link CocErrorHighlight ALEError
  highlight! link CocWarningHighlight ALEWarning
  highlight! link CocInfoHighlight ALEInfo
  " FIXME: This'll break if we ever switch away from gruvbox
  highlight! CocHintHighlight cterm=undercurl gui=undercurl guisp=#d3869b

  highlight! link CocErrorVirtualText ALEVirtualTextError
  highlight! link CocWarningVirtualText ALEVirtualTextWarning
  highlight! link CocInfoVirtualText ALEVirtualTextInfo
  highlight! link CocHintVirtualText GruvboxPurple

  highlight! link CocErrorFloat ALEVirtualTextError
  highlight! link CocWarningFloat ALEVirtualTextWarning
  highlight! link CocInfoFloat ALEVirtualTextInfo
  highlight! link CocHintFloat GruvboxPurple
endfunction

augroup on_change_colorscheme
  autocmd!
  autocmd ColorScheme * call s:gruvbox_customize()
augroup END

colorscheme gruvbox
