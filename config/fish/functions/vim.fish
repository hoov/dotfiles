function vim
    switch (uname)
        case Darwin
            mvim -v $argv
        case '*'
            command vim $argv
    end
end
