function! Textidote() abort
    if &filetype != 'tex'
        echo "Textitdote - Not a TeX file!!"
        return
    endif

    let entries = []
    let lines = split(system("textidote --output singleline --check pt --read-all --no-color " . expand("%")) . " 2&>/dev/null", '\n')

    for line in lines
        " let l:ml = matchlist(line, '^\(.*\)(L\([0-9]\+\)C\([0-9]\+\)-L\([0-9]\+\)C\([0-9]\+\)):\(.*\)"\(.*\)"')[1:7]
        let l:ml = matchlist(line, '^\(.*\)(L\([0-9]\+\)C\([0-9]\+\)-L\([0-9]\+\)C\([0-9]\+\)):\(.*\)')[1:6]
        " for i in range(0, len(l:ml)-1)
        "     echo '    ' . i . ': ' . l:ml[i]
        " endfor
        " echo ''
        if get(ml,0) != '0'
            call add(entries, { 'filename': get(ml,0), 'lnum': get(ml,1), 'col': get(ml,2), 'text': get(ml,5) })
        endif
    endfor

    if !empty(entries)
        call setqflist(entries)
        copen
    endif
endfunction
command! Textitdote call Textidote()
