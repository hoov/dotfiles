if test (uname) = "Darwin"
    function tmux
        command tmux -2 -f ~/.tmux-osx.conf $argv
    end
end
