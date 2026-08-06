" ============================================================================
" FUNCTION EXPLANATION:
" 1. l:current_buf captures the active buffer number using the '%' symbol.
" 2. 'bprevious' switches the window to the last viewed buffer to preserve layout.
" 3. The 'if' block checks if you only had one buffer open. If the current buffer
"    number hasn't changed, 'enew' opens a fresh, blank canvas.
" 4. 'execute' runs the 'bwipeout' command dynamically on the stored buffer ID,
"    deleting it entirely from your buffer list.
" ============================================================================
command! CloseBuffer call CloseAndWipeBuffer()

function! CloseAndWipeBuffer()
    let l:current_buf = bufnr('%')
    bprevious
    if bufnr('%') == l:current_buf
        enew
    endif
    execute 'bwipeout ' . l:current_buf
endfunction

" Source all files in folder
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

" Adds an char at the end
command! -nargs=1 EndWithChar call EndWithCharFunc(<f-args>)

function! EndWithCharFunc(endchar)
    :execute "normal! mqA" . a:endchar . "\<esc>`q"
endfunction

" Search a String in a file
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

function! SafeBufferCycle(direction)
    let l:cmd = a:direction > 0 ? 'bnext' : 'bprev'
    execute l:cmd
    " Loop again if the new buffer is NERDTree or a non-file buffer
    while &buftype ==# 'nofile' || bufname('%') =~# 'NERD_tree'
        execute l:cmd
    endwhile
endfunction

" Find cmds with path, from :commands list
command! -nargs=1 FindCmdByPath call FindCmdByPath(<q-args>)

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

" Command to search a string in files
command! -nargs=+ -complete=customlist,s:FindInFilesComplete FindInFiles call s:FindInFilesFunc(<q-args>)

" The Main Search Execution Function
function! s:FindInFilesFunc(args)
    let l:pattern = ''
    let l:remainder = ''

    " Check if the user's input starts with a double quote
    if a:args =~ '^"'
        " A simple regex without nested groups:
        " Group 1 captures everything between the first and second quote
        " Group 2 captures everything after the second quote and its following space
        let l:match = matchlist(a:args, '\v^"([^"]+)"\s+(.*)')
        if len(l:match) > 0
            let l:pattern = l:match[1]
            let l:remainder = l:match[2]
        endif
    endif

    " Fallback if no quotes were used or if the regex failed
    if empty(l:pattern)
        let l:first_space = match(a:args, '\s')
        if l:first_space == -1
            echoerr "Error: Missing path argument"
            return
        endif
        let l:pattern = a:args[:l:first_space - 1]
        let l:remainder = a:args[l:first_space + 1:]
    endif

    " Safety verification
    if empty(l:remainder)
        echoerr "Error: Missing path argument"
        return
    endif

    " Parse remainder into base path and extensions
    let l:parts = split(l:remainder, '\s\+')
    let l:base_path = l:parts[0]
    let l:base_path = substitute(l:base_path, '\/$', '', '') " Clean trailing slash

    " Build final target path string
    if len(l:parts) >= 2
        let l:path_list = []
        " Loop through all extension arguments starting from index 1
        for l:ext in l:parts[1:]
            if l:ext !~ '^\*'
                let l:cleaned_ext = substitute(l:ext, '^\.', '', '')
                let l:cleaned_ext = '*.' . l:cleaned_ext
            else
                let l:cleaned_ext = l:ext
            endif
            call add(l:path_list, l:base_path . '/**/' . l:cleaned_ext)
        endfor
        let l:final_paths = join(l:path_list, ' ')
    else
        let l:final_paths = l:base_path . '/**/*'
    endif

    " Execute search and open quickfix window
    execute 'vimgrep /' . l:pattern . '/j ' . l:final_paths
    copen
endfunction

" The Intelligent Tab-Completion Function
function! s:FindInFilesComplete(ArgLead, CmdLine, CursorPos)
    let l:parts = split(a:CmdLine[:a:CursorPos-1], '\s\+', 1)
    let l:arg_count = len(l:parts)

    if l:arg_count <= 2
        return []
    endif

    if l:arg_count == 3
        return map(getcompletion(a:ArgLead, 'file'), 'escape(v:val, " ")')
    endif

    return filter(['py', 'js', 'ts', 'html', 'css', 'md', 'json', 'cpp', 'h'], 'v:val =~ "^" . a:ArgLead')
endfunction
