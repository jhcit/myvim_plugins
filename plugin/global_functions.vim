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

command! -nargs=+ SearchInFile call SearchInFileFunc(<f-args>)
function! SearchInFileFunc(pattern, path, ...)
    let l:file_pattern = a:0 > 0 ? a:1 : '*'
    
    " Bygg upp söksträngen för vimgrep
    let l:search_path = a:path . '/**/' . l:file_pattern

    " Kör vimgrep. 'j' gör att Vim inte hoppar till första träffen direkt
    execute 'vimgrep /' . a:pattern . '/j ' . l:search_path

    " Öppna quickfix-fönstret
    copen
endfunction

