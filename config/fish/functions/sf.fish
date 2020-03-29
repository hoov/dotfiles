function sf
    if test -e bin/activate.fish
        . bin/activate.fish
    else if test -e env/bin/activate.fish
        . env/bin/activate.fish
    else if test -e lvenv/bin/activate.fish
        . lvenv/bin/activate.fish
    else if test -e venv/bin/activate.fish
        . venv/bin/activate.fish
    else
        echo "Directory doesn't seem to have a virtualenv"
    end
end
