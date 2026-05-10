command! -nargs=1 RustCreateFunction call CreateFunction(<f-args>)

function! CreateFunction(name)
    call append(line('.'), "}")
    call append(line('.'), "fn " . a:name . "{")
endfunction
