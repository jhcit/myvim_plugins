" Map a key to grep word where the cursor is at
" try to put the cursor at any word and do :echom shellescape(expand("<cWORD>"))
" the :exe command allows you to execute the command that understand <cr> as a key not string.

nnoremap <leader><leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader><leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

"  ==# means case sensitive
"  this function will act as operator, ie d, c etc commands and waiting for a motion
"  the char in the if statement is what returns when you are in visual mode v , char mode if its
"  normal mode on text.
function! s:GrepOperator(type)
    let saved_unnamed_register = @@
    if  a:type  ==# 'v'
        execute "normal! `<v`>y"
    elseif  a:type  ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen
    let @@ = saved_unnamed_register
endfunction

command! -nargs=+ MyGrep execute 'silent grep! <args> %' | copen

