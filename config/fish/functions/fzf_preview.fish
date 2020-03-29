function fzf_preview
    set -l max_len 100
    set -l mime_info (string split '; ' (file -bL --mime $argv[1]))

    if test (count $mime_info) -lt 2
        echo "$argv[1] doesn't exist"
    else if [ $mime_info[2] = "charset=binary" ]
        if [ $mime_info[1] = "inode/directory" ]
            tree -L 2 -CFax --filelimit=20 $argv[1] | sed '1d' | head -n $max_len
        else
            echo $argv[1] is a binary file
        end
    else
        begin
            bat --theme=base16 --color=always $argv[1]; or cat $argv[1]
        end | head -n $max_len
    end
end
