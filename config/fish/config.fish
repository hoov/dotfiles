set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config


# Add Rust to the path first since our prompt uses it
if test -d $HOME/.cargo/bin
    set PATH $HOME/.cargo/bin $PATH
end

if command -sq starship
    starship init fish | source
else
    set __fish_git_prompt_show_informative_status 'yes'

    set __fish_git_prompt_char_stagedstate '•'
    set __fish_git_prompt_char_dirtystate 'Δ'
    set __fish_git_prompt_char_invalidstate '⭠'
    set __fish_git_prompt_char_cleanstate '♦'
    set __fish_git_prompt_color_branch '5FD7FF'

end
# Remove Rust from path, since we're going to add it in at a higher priority later
set PATH (string match -v $HOME/.cargo/bin $PATH)

# We'll take care of it ourselves...
set VIRTUAL_ENV_DISABLE_PROMPT 'yes'

# Prefer /usr/local/bin and /usr/local/sbin
set PATH /usr/local/bin /usr/local/sbin $PATH

# And prefer the path in .local evn more
if test -d $HOME/.local/bin
    set PATH {$HOME}/.local/bin $PATH
end 

# Rust is most important
if test -d $HOME/.cargo/bin
    set PATH $HOME/.cargo/bin $PATH
end


if test -d "/Applications/YubiKey Manager.app/Contents/MacOS"
    set PATH "/Applications/YubiKey Manager.app/Contents/MacOS" $PATH
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

# This is a workaround for a bug in base16-fish
if not status --is-interactive
    set -e base16_theme
end

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

if command -sq rg
    set -gx FZF_FIND_FILE_COMMAND "rg --files --no-ignore-vcs --hidden \$dir 2> /dev/null"
    set -gx FZF_DEFAULT_COMMAND  "rg --files --no-ignore-vcs --hidden"
else
    set -e FZF_FIND_FILE_COMMAND
    set -e FZF_DEFAULT_COMMAND
end

set -gx FZF_LEGACY_KEYBINDINGS 0
set -gx FZF_TMUX 1
set -gx FZF_ENABLE_OPEN_PREVIEW 1

if command -sq bat
    set -gx FZF_PREVIEW_FILE_CMD fzf_preview
    set -gx FZF_PREVIEW_DIR_CMD fzf_preview

    set -gx BAT_PAGER "less -FR"
    alias man batman
else
    set -e FZF_PREVIEW_FILE_CMD
    set -e FZF_PREVIEW_DIR_CMD
end

if command -sq npx
    source (npx --shell-auto-fallback fish | psub)
end

if command -sq dircolors; and not set -q LS_COLORS
    eval (dircolors -c ~/.dircolors)
end

if test -d /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/
    builtin source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
end

# Completions
if test -e /Applications/Docker.app/Contents/Resources/etc/docker.fish-completion
    builtin source /Applications/Docker.app/Contents/Resources/etc/docker.fish-completion
end

# Aliases
if command ls --version > /dev/null 2>&1
    # We have a GNU ls
    alias ls="ls --color=always --classify"
else
    alias ls="ls -G"
end

alias lla="ls -lha"

alias pw="pass show -c"

if command -sq nvim.appimage
    alias vim=nvim.appimage
    set -gx EDITOR nvim.appimage
else if command -sq nvim
    alias vim=nvim
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end

if command -sq kitty
    kitty + complete setup fish | source
end

if status --is-interactive
    base16-gruvbox-dark-medium

    command -sq rbenv; and source (rbenv init -|psub)
    command -sq nodenv; and source (nodenv init -|psub)
    test -e {$HOME}/.asdf/asdf.fish; and source {$HOME}/.asdf/asdf.fish
    source ~/.config/fish/gnupg.fish
end
