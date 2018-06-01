if type -q nvim
    function vim --wraps vim
        command nvim $argv
    end
end
