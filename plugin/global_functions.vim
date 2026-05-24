command! ReSourceAll call SourceAllScripts()
function! SourceAllScripts()
    redir => s
    silent scriptnames
    redir END

    for line in split(s, "\n")
        let file = matchstr(line, '\S\+$')
        if filereadable(file)
            execute 'source' file
        endif
    endfor
endfunction

command! -nargs=1 EndWithChar call EndWithCharFunc(<f-args>)
function! EndWithCharFunc(endchar)
    :execute "normal! mqA" . a:endchar . "\<esc>`q"
endfunction

command! -nargs=* SearchInFile call SearchInFileFunc(<f-args>)
function! SearchInFileFunc(s_pattern, ...)
    let pattern = a:s_pattern
    let path = get(a:, 1, "./")
    let file_pattern = get(a:, 2, "*")

    :execute "echom \"not implemented yet\" "
    :execute "echom \"Searching for \" . pattern"
    :execute "echom \"Searching in \"  . path"
    :execute "echom \"Searching on files \"  . file_pattern"
endfunction



