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

function! EndWithCharFunc(endchar)
    :execute "normal! mqA" . a:endchar . "\<esc>`q"
endfunction

function! SearchInFileFunc(pattern, path, ...)
    let l:file_pattern = a:0 > 0 ? a:1 : '*'
    
    " Bygg upp söksträngen för vimgrep
    let l:search_path = a:path . '/**/' . l:file_pattern

    " Kör vimgrep. 'j' gör att Vim inte hoppar till första träffen direkt
    execute 'vimgrep /' . a:pattern . '/j ' . l:search_path

    " Öppna quickfix-fönstret
    copen
endfunction

function! SafeBufferCycle(direction)
    let l:cmd = a:direction > 0 ? 'bnext' : 'bprev'
    execute l:cmd
    " Loop again if the new buffer is NERDTree or a non-file buffer
    while &buftype ==# 'nofile' || bufname('%') =~# 'NERD_tree'
        execute l:cmd
    endwhile
endfunction

function! FindCmdByPath(path_keyword)
    redraw!
    if empty(a:path_keyword)
        echoerr "Please provide a path keyword. Usage: :FindCmdByPath global_commands"
        return
    endif

    echo "--- Loaded Commands Matching Path: '" . a:path_keyword . "' ---"
    echo printf("%-20s %s", "Command Name", "Source Location")
    echo repeat("-", 70)

    " Capture live output of 'verbose command'
    silent let l:cmd_out = execute('verbose command')
    let l:lines = split(l:cmd_out, "\n")
    let l:idx = 0

    while l:idx < len(l:lines) - 1
        let l:cmd_line = l:lines[l:idx]
        
        " Verify line contains a command definition (skips headers/blank formatting)
        if l:cmd_line !~# '^\s*Last set from' && l:cmd_line !~# '^\s*Name\s\+Args' && l:cmd_line =~# '[A-Z]'
            let l:path_line = l:lines[l:idx + 1]
            
            " Verify the next line marks the source location path
            if l:path_line =~# 'Last set from'
                
                " Match against both literal text (~) and expanded system path (/home/...)
                let l:match_raw = (stridx(tolower(l:path_line), tolower(a:path_keyword)) != -1)
                let l:match_expanded = (stridx(tolower(l:path_line), tolower(expand(a:path_keyword))) != -1)
                
                if l:match_raw || l:match_expanded
                    " Extract clean command name
                    let l:parts = split(l:cmd_line)
                    let l:cmd_name = (l:parts[0] =~# '^[!b]$') ? l:parts[1] : l:parts[0]
                    
                    " Extract clean file location text
                    let l:source_file = matchstr(l:path_line, 'Last set from \zs.*$')
                    
                    echo printf("%-20s %s", l:cmd_name, l:source_file)
                endif
            endif
        endif
        let l:idx += 1
    endwhile
endfunction

function! PushYankToHistory()
    " Only execute if it's a true yank action (ignores deletes)
    if v:event.operator == 'y'
        " 1. Shift numbered registers 8 down to 9, 7 to 8, etc.
        let l:i = 8
        while l:i >= 1
            execute 'let @' . (l:i + 1) . ' = @' . l:i
            let l:i -= 1
        endwhile
        
        " 2. Grab the text from the unnamed register and clone it to @1
        let @1 = @"
    endif
endfunction

