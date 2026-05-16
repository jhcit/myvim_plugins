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


