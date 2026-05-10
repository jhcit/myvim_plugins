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

inoremap <leader><Tab> <Space><Space><Space><Space>

" autosave on esc when in insert mode
inoremap <esc> <esc>:w<cr>

" surround texts on visual marked text
vnoremap '' di''<esc>P
vnoremap "" di""<esc>P
vnoremap [[ di[]<esc>P
vnoremap {{ di{}<esc>P
vnoremap (( di()<esc>P
vnoremap << di<><esc>P

" Nerd tree related see github.com/preservim/nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

