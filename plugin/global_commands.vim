" Run :SourceFolder ~/.my-vim-configs/ to source all .vim files in it
command! -nargs=1 -complete=dir SourceFolder for f in split(glob(<q-args> . '/*.vim'), '\n') | execute 'source' f | endfor

" Find all my own commands from a path
command! -nargs=? MyCmds if empty(<q-args>) | execute 'vimgrep /^\s*command!/ %' | else | execute 'vimgrep /^\s*command!.*'.<q-args>.'/ %' | endif | copen

" Source all files in folder
command! ReSourceAll call SourceAllScripts()

" Adds an char at the end
command! -nargs=1 EndWithChar call EndWithCharFunc(<f-args>)

" Search a String in a file
command! -nargs=+ SearchInFile call SearchInFileFuncf-args>)

" Find cmds with path, from :commands list
command! -nargs=1 FindCmdByPath call FindCmdByPath(<q-args>)
