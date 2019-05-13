set number
set tabstop=4
" tabs are 8 spaces in onvm

syntax on
" set syntax highlighting

inoremap ( ()<Esc>i

inoremap { {}<Esc>i

nnoremap <NL> i<CR><ESC>
" split line at cursor

" indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab
