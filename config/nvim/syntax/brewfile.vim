if exists("b:current_syntax")
  finish
endif

source $VIMRUNTIME/syntax/ruby.vim
unlet b:current_syntax

syntax keyword brewfileKeyword brew cask cask_args mas tap

highlight link brewfileKeyword Keyword

let b:current_syntax = 'brewfile'
