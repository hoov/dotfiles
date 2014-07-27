function vim
    if test (uname) = Darwin
        mvim -v $argv;
    else
        command vim $argv;
    end
end
