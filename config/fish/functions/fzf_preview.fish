function fzf_preview
    set bat_args --theme=base16 --color=always --style=numbers
    set -l max_len 100
    set -l mime_info (string split '; ' (file -bL --mime $argv[1]))

    if test (count $mime_info) -lt 2
        echo "$argv[1] doesn't exist"
    else 
        switch $mime_info[1]
            case "text/*"
                bat $bat_args $argv
            case application/json
                bat $bat_args -l json $argv
            case image/{gif,jpeg,png,svg+xml,webp}
                timg -g (math $COLUMNS - 2)x$LINES --frames 1 $argv
            case application/{msword,vnd.{ms-excel,ms-powerpoint,openxmlformats-officedocument.{presentationml.presentation,spreadsheetml.sheet,wordprocessingml.document}},pdf} image/heic video/{mp4,x-matroska}
                set tmp (mktemp -d)
                qlmanage -t -s (math $COLUMNS x 8) -o $tmp $argv &> /dev/null
                fzf_preview $tmp/*
                rm -r $tmp
            case application/{gzip,x-{7z-compressed,bzip2,rar,xar},zip}
                7z l $argv | tail -n +12
            case \*
                echo (file -b $argv) "($mime_info[1])"
        end
    end
end
