if type -q hub
    function git --description 'Alias for hub, which wraps git to provide extra functionality with GitHub.' --wraps hub
        command hub $argv
    end
end
