nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Smart bnext: Skip NERDTree when pressing Shift + Right Arrow
nnoremap <silent> <S-Right> :call SafeBufferCycle(1)<CR>

" Smart bprev: Skip NERDTree when pressing Shift + Left Arrow
nnoremap <silent> <S-Left> :call SafeBufferCycle(-1)<CR>


" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
