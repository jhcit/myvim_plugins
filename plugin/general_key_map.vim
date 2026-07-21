let mapleader="  "

inoremap <S-Tab> <C-V><Tab>
inoremap <C-Tab> <Tab>

nnoremap <Leader>bd :b#<bar>bd#<CR>
nnoremap <F9> <F1>
nnoremap <F1> <NOP>

" If you also use F1 inside insert mode or command-line mode:
inoremap <F9> <F1>
inoremap <F1> <NOP>
cnoremap <F9> <F1>
cnoremap <F1> <NOP>

" move the key to the beginning of a line
nnoremap H 0

" move the key to the end of a line
nnoremap L $

" change the working directory to the file you are opening and only locally
nnoremap <leader>cd :lcd %:h<CR>

" close the brackets automatically 
nnoremap <leader>( i()<Esc>
nnoremap <leader>{ i{}<Esc>
nnoremap <leader>[ i[]<Esc>
nnoremap <leader>< i<><Esc>

" copy  to a specific register
nnoremap <Leader>y :execute 'normal! "' . nr2char(getchar()) . 'y' . v:count1 . visualmode()<CR>
vnoremap <Leader>y :<C-u>execute 'normal! gv"' . nr2char(getchar()) . 'y'<CR>

" paste from a specific register
nnoremap <Leader>p :execute 'normal! "' . nr2char(getchar()) . 'p'<CR>
vnoremap <Leader>p :<C-u>execute 'normal! gv"' . nr2char(getchar()) . 'p'<CR>

" Inserts tabs or spaces based on your exact shiftwidth/expandtab settings
inoremap <expr> <Leader><Tab> pumvisible() ? "\<C-V>\<Tab>" : "\<C-G>u\<Tab>"

" autosave on esc when in insert mode
inoremap <esc> <esc>:w<cr>

" surround texts on visual marked text
vnoremap '' di''<esc>P
vnoremap "" di""<esc>P
vnoremap [[ di[]<esc>P
vnoremap {{ di{}<esc>P
vnoremap (( di()<esc>P
vnoremap << di<><esc>P
