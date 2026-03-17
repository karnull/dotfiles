
" Define custom commands
command! W w
command! Wq wq

" Set key mappings
nnoremap s "_d
vnoremap s "_d
nnoremap S "_d$a
nnoremap X "_x
nnoremap sA gg"_dG
nnoremap dA :%delete<CR>
nnoremap yA :%yank<CR>
