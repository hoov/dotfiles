set fish_color_user 'AF5FFF'
set fish_color_host 'FF6600'
set fish_color_cwd '00FF00'
set fish_color_status 'FF0000'

set __fish_git_prompt_show_informative_status 'yes'

set __fish_git_prompt_char_stagedstate '•'
set __fish_git_prompt_char_dirtystate 'Δ'
set __fish_git_prompt_char_invalidstate '⭠'
set __fish_git_prompt_char_cleanstate '♦'
set __fish_git_prompt_color_branch '5FD7FF'

# We'll take care of it ourselves...
set VIRTUAL_ENV_DISABLE_PROMPT 'yes'

# Prefer /usr/local/bin
set PATH /usr/local/bin $PATH

# And prefer the path in .local evn more
set PATH {$HOME}/.local/bin $PATH

function __add_gnubin
  if test -e /usr/local/opt/$argv[1]/libexec/gnubin
    set PATH /usr/local/opt/$argv[1]/libexec/gnubin $PATH
  end
end

switch (uname)
  case Darwin
    set -x JAVA_HOME (/usr/libexec/java_home)
    # If coretuils is installed, prefer those
    if type -q brew
      for pkg in coreutils findutils gnu-sed
        __add_gnubin $pkg
      end

      test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
    end
  case Linux
    set -x JAVA_HOME (readlink -f /usr/bin/java | sed "s:jre/bin/java::")
end

if type -q powerline-daemon
  set -gx POWERLINE_HOME (pip show powerline-status 2>/dev/null | grep Location | cut -f2 -d" ")
end

if test -f $HOME/.homebrew-github-token
  set -x HOMEBREW_GITHUB_API_TOKEN (cat $HOME/.homebrew-github-token)
end

if type -q nvim
  set -gx EDITOR nvim
else
  set -gx EDITOR vim
end

# I think this was for Yubikey stuff
#if test -f $HOME/.gpg-agent-info
#  eval (sed -e 's/^\(.*\)=\(.*\)$/set \1 \2/' ~/.gpg-agent-info | tr '\n' '; ')
#end

# Fisherman stuff
set -U fish_path $HOME/.config/fisherman-plugins

for file in $fish_path/conf.d/*.fish
  builtin source $file ^ /dev/null
end

set fish_function_path $fish_path/functions $fish_function_path
set fish_complete_path $fish_path/completions $fish_complete_path

if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-solarized-dark.sh

  type -q rbenv; and source (rbenv init -|psub)
  type -q nodenv; and source (nodenv init -|psub)
end
