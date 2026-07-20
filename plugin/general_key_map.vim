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

" Smart bnext: Skip NERDTree when pressing Shift + Right Arrow
nnoremap <silent> <S-Right> :call SafeBufferCycle(1)<CR>

" Smart bprev: Skip NERDTree when pressing Shift + Left Arrow
nnoremap <silent> <S-Left> :call SafeBufferCycle(-1)<CR>

" Escape terminal and get to normal text edit mode press I to get back in terminal  mode
tnoremap <Esc><Esc> <C-w>N
