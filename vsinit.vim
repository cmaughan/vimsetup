" Mappings {{{1
" My prefered escape character (j then k)
inoremap jk <esc>
"tnoremap jk <C-\><C-n>

" Move by buffer lines
nnoremap j gj
nnoremap k gk
nnoremap gk k
nnoremap gj j

" Control + motion for window move
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set relativenumber
set ignorecase
set smartcase
set incsearch
set hlsearch

" H and L for tab switching
nnoremap H gT
nnoremap L gt

let mapleader = ","
let maplocalleader = ","

" Remove all white space trailing
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Remove highlight selection
nnoremap <leader><space> :noh<cr> :MarkClear<cr>

" Replace word under cursor
nnoremap <Leader>rw :%s/\<<C-r><C-w>\>//g<Left><Left>

" Edit in window at current directory
" Edit in split at current directory
" Open VimRC in window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>es :vsp <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

