" Extenstion to Ctrl-f in command mode to copy and paste from specific registers
autocmd CmdwinEnter * nnoremap <buffer> <Leader>y :execute 'normal! "' . nr2char(getchar()) . 'y' . v:count1 . visualmode()<CR>

autocmd CmdwinEnter * nnoremap <buffer> <Leader>p :execute 'normal! "' . nr2char(getchar()) . 'p'<CR>

" Automatically fire the function after ANY native yank finishes
autocmd TextYankPost * call PushYankToHistory()
