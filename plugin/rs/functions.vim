function! HN_new_struct(argument)
    execute "normal! i" . "struct " . a:argument . " {\n\n}" 
endfunction

command! -nargs=1 RustNewStruct call HN_new_struct(<f-args>)

function! HN_new_function(argument)
    execute "normal! i" . "fn " . a:argument . "()" . " {\n\n}" 
endfunction

command! -nargs=1 RustNewFn call HN_new_function(<f-args>)

