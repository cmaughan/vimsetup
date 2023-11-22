-- esc --
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('t', 'jk', [[<C-\><C-n>]])

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<c-left>', 'gt')
vim.keymap.set('n', '<c-right>', 'gT')

vim.keymap.set('t', '<c-k>', '<C-\\><C-n> :wincmd k<CR>')
vim.keymap.set('t', '<c-j>', '<C-\\><C-n> :wincmd j<CR>')
vim.keymap.set('t', '<c-h>', '<C-\\><C-n> :wincmd h<CR>')
vim.keymap.set('t', '<c-l>', '<C-\\><C-n> :wincmd l<CR>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Disable arrow keys
vim.keymap.set('', '<up>', '<nop>')
vim.keymap.set('', '<down>', '<nop>')
vim.keymap.set('', '<left>', '<nop>')
vim.keymap.set('', '<right>', '<nop>')

-- Map Esc to kk
vim.keymap.set('i', 'jk', '<Esc>')

-- Clear search highlighting with <leader> and c
vim.keymap.set('n', '<leader><space>', ':nohl<CR>')

-- Toggle auto-indenting for code paste
vim.keymap.set('n', '<F2>', ':set invpaste paste?<CR>')
--vim.opt.pastetoggle = '<F2>'

-- Change split orientation
vim.keymap.set('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
vim.keymap.set('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')

-- Terminal vim.keymap.setpings
vim.keymap.set('n', '<C-\\>', ':Term<CR>', { noremap = true })  -- open
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')                    -- exit

vim.keymap.set('n', '<leader>ev', '<C-w><C-v><C-l>:e $MYVIMRC<CR>') -- edit vim

vim.keymap.set('n', '<leader>z', ':ZenMode<CR>')

vim.keymap.set('n', '<leader>ws', ':call WindowSwap#EasyWindowSwap()<CR>')
