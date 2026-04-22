echom "html file"
set omnifunc=htmlcomplete#CompleteTags

" auto close some known elements
inoremap <p<Tab> <p></p><Esc> 
inoremap <div<Tab> <div></div><Esc> 
