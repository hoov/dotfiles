gpgconf --launch gpg-agent
set -x GPG_TTY (tty)
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
