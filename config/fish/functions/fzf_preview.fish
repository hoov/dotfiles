function fzf_preview
    set -l mime_info (string split '; ' (file -bL --mime $argv[1]))

    if test (count $mime_info) -lt 2
        echo "$argv[1] doesn't exist"
    else if [ $mime_info[2] = "charset=binary" ]
        if [ $mime_info[1] = "inode/directory" ]
            echo $argv[1] is a directory
        else
            echo $argv[1] is a binary file
        end
    else
        begin
            bat --theme=base16 --color=always $argv[1]; or cat $argv[1]
        end | head -n 50
    end
end
