let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Setup {{{1
set nocompatible

let $PATH .= ';' . $MYDROPBOX . '/Dev/bin/LLVM/bin'

lua require('plugins')
lua require('config')

" GVim required the runtime path to contain the startup script folder
let &runtimepath.=','.escape(expand('<sfile>:p:h'), '\,')
let &runtimepath.=','.escape(expand('<sfile>:p:h').'/bundle', '\,')
filetype off

let loaded_matchit = 1
let g:python3_host_prog = expand('~/.pyenv/pyenv-win/shims/python')

call plug#begin('~/.vim/plugged')
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

Plug 'BurntSushi/ripgrep'
Plug 'tpope/vim-fugitive'            " Git support
Plug 'tpope/vim-surround'            " Surround section with ', etc.
Plug 'tpope/vim-unimpaired'          " Useful mappings ([<space etc)
Plug 'easymotion/vim-easymotion'     " easy jumping around - ,,w
Plug 'derekwyatt/vim-fswitch'        " Switch between cpp/header. FSHere, FSRight
Plug 'mtth/scratch.vim'              " gs scratch window
Plug 'kien/rainbow_parentheses.vim'  " Color brackets
Plug 'dahu/VimRegexTutor'            " Regex tutorial; need to do this
Plug 'vim-scripts/mru.vim'           " :MRU
Plug 'jlanzarotta/bufexplorer'       " :be
Plug 'skywind3000/asyncrun.vim'
Plug 'szw/vim-maximizer'             " F3 to min/max the current buffer
Plug 'junegunn/vim-easy-align'
Plug 'RRethy/vim-illuminate'

" Lisp
Plug 'kovisoft/paredit', { 'for': 'scheme' }
Plug 'yegappan/taglist'
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'lervag/vimtex'

Plug 'arcticicestudio/nord-vim'

let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1

" Swift
Plug 'keith/swift.vim'
Plug 'sk1418/HowMuch'

" Animated and auto sizing windows
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'

" Janet
Plug 'Olical/conjure'
Plug 'bakpakin/janet.vim'

" Wiki
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'

Plug 'OrangeT/vim-csharp'
Plug 'markonm/traces.vim'

" UsFZF for searching in files using Rg
Plug 'junegunn/fzf'                  " Fuzzy finder
Plug 'junegunn/fzf.vim'              " Fuzzy finder vim extension

Plug 'kovisoft/slimv'

Plug 'mh21/errormarker.vim'

Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'

Plug 'frazrepo/vim-rainbow'

Plug 'nvim-lualine/lualine.nvim'

runtime vsinit.vim

call plug#end()

" Thanks to https://forums.handmadehero.org/index.php/forum?view=topic&catid=4&id=704#3982
"
" error message formats
" Microsoft MSBuild
set errorformat+=\\\ %#%f(%l\\\,%c):\ %m
" Microsoft compiler: cl.exe
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
" Microsoft HLSL compiler: fxc.exe
set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m

let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
filetype plugin indent on
filetype plugin on

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"

" Vim Rainbow
let g:rainbow_active = 1

"Telescope {{{2
" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

lua << EOF
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous"
      }
    }
  },
}
EOF

" FSwitch {{{2
let g:fsnonewfiles=1
au! BufEnter *.cpp let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = 'reg:/src/include,reg:|src|include/zep|,../Inc/**/,../include,source'
au! BufEnter *.h let b:fswitchdst = 'cpp' | let b:fswitchlocs = 'reg:/include/src/,reg:|include.*zep|include/src|src|,rel:../../src,source'

" Rainbow Parentheses {{{2
try
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
catch
endtry

let g:mucomplete#enable_auto_at_startup = 1
"These broke VC; what were they for?
"inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
"inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
"inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")


nnoremap <Leader>g :silent lgrep<Space>

" RipGrep {{{2
let g:ackprg = 'rg --vimgrep --no-heading'

" Vim Fugitive {{{2
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" Minibuf Explorer {{{2
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" UltiSnips {{{2 
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = $MYDROPBOX . '/Snippets'
let g:UltiSnipsSnippetDirectories = [$MYDROPBOX . '/Snippets']

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<c-,>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" VimWiki {{{2
let g:vimwiki_list = [{'path': $MYDROPBOX.'/vimwiki/'},
            \   {'path': $MYDROPBOX.'/techwiki/'}]

hi VimwikiHeader1 guifg=#FDA01F
hi VimwikiHeader2 guifg=#22DD11
hi VimwikiHeader3 guifg=#99BBFF
hi VimwikiHeader4 guifg=#FF00FF
hi VimwikiHeader5 guifg=#00FFFF
hi VimwikiHeader6 guifg=#FFFF00
hi link VimwikiLink Typedef

au BufRead,BufNewFile *.wiki set filetype=vimwiki
function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction

:map >> <Plug>VimwikiIncreaseLvlSingleItem
:map >>> <Plug>VimwikiIncreaseLvlWholeItem
:map << <Plug>VimwikiDecreaseLvlSingleItem
:map <<< <Plug>VimwikiDecreaseLvlWholeItem

" VimScratch {{{2
let g:scratch_persistence_file=$MYDROPBOX.'/vimscratch.txt'

" Align 'then' two spaces after 'if'
let g:haskell_indent_if = 2
" Indent 'where' block two spaces under previous body
let g:haskell_indent_before_where = 2
" Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_case_alternative = 1
" Only next under 'let' if there's an equals sign
let g:haskell_indent_let_no_in = 0

" ----- hindent & stylish-haskell -----
" Indenting on save is too aggressive for me
let g:hindent_on_save = 0 

" Helper function, called below with mappings
function! HaskellFormat(which) abort
  if a:which ==# 'hindent' || a:which ==# 'both'
    :Hindent
  endif
  if a:which ==# 'stylish' || a:which ==# 'both'
    silent! exe 'undojoin'
    silent! exe 'keepjumps %!stylish-haskell'
  endif
endfunction

" Key bindings
augroup haskellStylish
  au!
  " Just hindent
  au FileType haskell nnoremap <leader>hi :Hindent<CR>
  " Just stylish-haskell
  au FileType haskell nnoremap <leader>hs :call HaskellFormat('stylish')<CR>
  " First hindent, then stylish-haskell
  au FileType haskell nnoremap <leader>hf :call HaskellFormat('both')<CR>
augroup END

" ASyncRun {{
:noremap <F8> :cnext <cr>
:noremap <S-F8> :cprev <cr>

" automatically open quickfix window when AsyncRun command is executed
" set the quickfix window 6 lines height.
let g:asyncrun_open = 6

" ring the bell to notify you job finished
let g:asyncrun_bell = 1

" F10 to toggle quickfix window
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

" Leaders {{{1

nnoremap <Leader>gd :Gvdiff<CR>

" Searching
nnoremap <Leader>, :Find <CR>
nnoremap <Leader>. :CtrlPTag<cr>

" Tag list and tag jump
nnoremap <Leader>gt g<C-]>
nnoremap <Leader>t <C-]>

" Reselect text that was just pasted
nnoremap <leader>v V`]

"nnoremap <leader>fp :args **/*.vcxproj<cr>:silent! argdo %s/<ClCompile.*\.h.*//g<cr>

nnoremap <Leader>f :set nomore<Bar>:ls<Bar>:set more<CR>:b<Space>

" Insert date
nnoremap <Leader>d i<C-R>=strftime("%F - %A %d %B\n\n")<cr>

" Edit in split at current directory
" Open VimRC in window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>


" Commands {{{1
command! MakeTags !ctags -R .
command! MakeTags !ctags -R .
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
nnoremap + :Bigger<CR>
nnoremap - :Smaller<CR>

" Command for git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Auto Commands {{{1
autocmd FileType c,cpp setlocal equalprg=clang-format
" autocmd GUIEnter * simalt ~x

" Save when focus is lost
autocmd FocusLost * :wa
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufEnter * lcd %:p:h


" Options {{{1
set omnifunc=syntaxcomplete#Complete
"set guioptions-=m  "remove menu bar
set guioptions+=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set list
set listchars=tab:>-,eol:\ ,space:.,nbsp:~,extends:$
set modelines=0
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set foldmethod=marker
set equalalways

"vimwiki
set nocompatible
syntax on

" Breaks vis white space
set nocursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set showmatch

"set guifont=h11:cANSI:qDRAFT

" Dark goodness
set background=dark
set termguicolors
" colorscheme carbonfox
colorscheme tokyonight-night

" Mappings {{{1

"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" F9 folds
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" Swap files between source header
map <C-k><C-o> :FSHere<CR>
map <C-k><C-o> :FSHere<CR>
map <C-k><C-l> :FSRight<CR>
map <C-k><C-v> :FSSplitRight<CR>
map <C-k><C-W> :FSLeft<CR>

" Terminal fixes
" conflict with searches.  Used to switch windows while editing
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
tnoremap jk <C-\><C-n>

nnoremap <C-k><C-d> gg=G''

set spell
set spell spelllang=en_us
inoremap <C-L> <c-g>u<Esc>[s1z=`]a<c-g>u

" Tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
let notabs = 0
nnoremap <silent> <F6> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>

" Functions {{{1
function! SetGitDir()
    " Change working dir to the current file
    cd %:p:h
    " Set 'gitdir' to be the folder containing .git
    let gitdir=system("git rev-parse --show-toplevel")
    " See if the command output starts with 'fatal' (if it does, not in a git repo)
    let isnotgitdir=matchstr(gitdir, '^fatal:.*')
    " If it empty, there was no error. Let's cd
    if empty(isnotgitdir)
        cd `=gitdir`
    endif
endfunction

nnoremap <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" }}} vim: fdm=marker
