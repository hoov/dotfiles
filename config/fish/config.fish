set fish_color_user 'AF5FFF'
set fish_color_host 'FF6600'
set fish_color_cwd '00FF00'

set __fish_git_prompt_show_informative_status 'yes'

set __fish_git_prompt_char_stagedstate '•'
set __fish_git_prompt_char_dirtystate 'Δ'
set __fish_git_prompt_char_invalidstate '⭠'
set __fish_git_prompt_char_cleanstate '♦'
set __fish_git_prompt_color_branch '5FD7FF'

# We'll take care of it ourselves...
set VIRTUAL_ENV_DISABLE_PROMPT 'yes'

set -x JAVA_HOME (/usr/libexec/java_home)

if test -e $HOME/.awscreds
    set -x AWS_CREDENTIAL_FILE $HOME/.awscreds
end

if test -e /usr/local/Library/LinkedKegs/aws-iam-tools/jars 
    set -x AWS_IAM_HOME /usr/local/Library/LinkedKegs/aws-iam-tools/jars
end

