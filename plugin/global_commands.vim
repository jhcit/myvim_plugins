" Run :SourceFolder ~/.my-vim-configs/ to source all .vim files in it
command! -nargs=1 -complete=dir SourceFolder for f in split(glob(<q-args> . '/*.vim'), '\n') | execute 'source' f | endfor
