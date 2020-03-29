command -v >/dev/null 2>&1 || source <(npx --shell-auto-fallback bash)

export PATH="$HOME/.cargo/bin:$PATH"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

source /Users/hoov/Library/Preferences/org.dystroy.broot/launcher/bash/br
