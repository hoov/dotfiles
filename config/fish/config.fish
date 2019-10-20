set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

if command -sq starship
    eval (starship init fish)
else
    set __fish_git_prompt_show_informative_status 'yes'

    set __fish_git_prompt_char_stagedstate '•'
    set __fish_git_prompt_char_dirtystate 'Δ'
    set __fish_git_prompt_char_invalidstate '⭠'
    set __fish_git_prompt_char_cleanstate '♦'
    set __fish_git_prompt_color_branch '5FD7FF'

end

# We'll take care of it ourselves...
set VIRTUAL_ENV_DISABLE_PROMPT 'yes'

# Prefer /usr/local/bin and /usr/local/sbin
set PATH /usr/local/bin /usr/local/sbin $PATH

# And prefer the path in .local evn more
if test -e $HOME/.local/bin
    set PATH {$HOME}/.local/bin $PATH
end 
# Rust
if test -e $HOME/.cargo/bin
    set PATH $HOME/.cargo/bin $PATH
end

function __add_gnubin
    if test -e /usr/local/opt/$argv[1]/libexec/gnubin
        set PATH /usr/local/opt/$argv[1]/libexec/gnubin $PATH
  end
end

set fish_complete_path $fish_complete_path[1] {$HOME}/.asdf/completions $fish_complete_path[2..-1]

switch (uname)
case Darwin
    set -x JAVA_HOME (/usr/libexec/java_home)
    # If coretuils is installed, prefer those
    if command -sq brew
        for pkg in coreutils findutils gnu-sed
            __add_gnubin $pkg
        end
    end
    test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
    if test -e /usr/local/opt/ncurses/bin
        set PATH /usr/local/opt/ncurses/bin $PATH
        set -gx LDFLAGS "-L/usr/local/opt/ncurses/lib"
        set -gx CPPFLAGS "-I/usr/local/opt/ncurses/include"
        set -gx PKG_CONFIG_PATH "/usr/local/opt/ncurses/lib/pkgconfig"
    end
case Linux
    set -x JAVA_HOME (readlink -f /usr/bin/java | sed "s:jre/bin/java::")
end

if command -sq powerline-daemon
    set -gx POWERLINE_HOME (pip show powerline-status 2>/dev/null | grep Location | cut -f2 -d" ")
end

# WSL specific stuff here
if test -e /proc/version; and grep -q microsoft /proc/version
    set -gx DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
end

for file in $XDG_CONFIG_HOME/fish/local.d/*.fish
    builtin source $file ^ /dev/null
end

# Fisherman
set -g fisher_path $XDG_CONFIG_HOME/fisherman-plugins

# Bootstrap fisherman if it doesn't exist
if not functions -q fisher
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

if command -sq rg
    set -U FZF_FIND_FILE_COMMAND "rg --files --no-ignore-vcs --hidden \$dir 2> /dev/null"
    set -U FZF_DEFAULT_COMMAND  "rg --files --no-ignore-vcs --hidden"
else
    set -e FZF_FIND_FILE_COMMAND
    set -e FZF_DEFAULT_COMMAND
end
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_TMUX 1
set -U FZF_ENABLE_OPEN_PREVIEW 1

if command -sq bat
    set -U FZF_PREVIEW_FILE_CMD fzf_preview
else
    set -e FZF_PREVIEW_FILE_CMD
end

if command -sq dircolors; and not set -q LS_COLORS
    eval (dircolors -c ~/.dircolors)
end

# Aliases
if command ls --version > /dev/null 2>&1
    # We have a GNU ls
    alias ls="ls --color=always --classify"
else
    alias ls="ls -G"
end

alias lla="ls -lha"

if command -sq nvim.appimage
    alias vim=nvim.appimage
else if command -sq nvim
    alias vim=nvim
else
    set -gx EDITOR vim
end
set -gx EDITOR vim

if status --is-interactive
    base16-gruvbox-dark-medium

    command -sq rbenv; and source (rbenv init -|psub)
    command -sq nodenv; and source (nodenv init -|psub)
    test -e {$HOME}/.asdf/asdf.fish; and source {$HOME}/.asdf/asdf.fish
end
