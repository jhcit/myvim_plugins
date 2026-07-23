" Run :SourceFolder ~/.my-vim-configs/ to source all .vim files in it
command! -nargs=1 -complete=dir SourceFolder for f in split(glob(<q-args> . '/*.vim'), '\n') | execute 'source' f | endfor

" Find all my own commands from a path
command! -nargs=? MyCmds if empty(<q-args>) | execute 'vimgrep /^\s*command!/ %' | else | execute 'vimgrep /^\s*command!.*'.<q-args>.'/ %' | endif | copen

