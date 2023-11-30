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

-- Move visual selection up and down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- Append to line, keep cursor at beginning
vim.keymap.set('n', 'J', "mzJ`z")

-- Keep cursor in middle while going up/down
vim.keymap.set('n', '<c-d>', "<c-d>zz")
vim.keymap.set('n', '<c-u>', "<c-u>zz")
vim.keymap.set('n', '<c-f>', "<c-f>zz")
vim.keymap.set('n', '<c-b>', "<c-b>zz")

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Ignore this
vim.keymap.set('n', 'Q', "<nop>")

-- Quickfix
-- vim.keymap.set('n', '<F8>', "<cmd>cnext<CR>zz")
--vim.keymap.set('n', '<S-F8>', "<cmd>cprev<CR>zz")
--vim.keymap.set('n', '<leader>k', "<cmd>lnext<CR>zz")
--vim.keymap.set('n', '<leader>j', "<cmd>lprev<CR>zz")

-- Ignore arrows
vim.keymap.set('', '<up>', '<nop>')
vim.keymap.set('', '<down>', '<nop>')
vim.keymap.set('', '<left>', '<nop>')
vim.keymap.set('', '<right>', '<nop>')

-- Paste over and keep selection
vim.keymap.set('x', '<leader>p', "\"_dP")

-- Map Esc to kk
vim.keymap.set('i', 'jk', '<Esc>')

-- Clear search highlighting with <leader> and c
vim.keymap.set('n', '<leader><space>', ':nohl<CR>')

-- Toggle auto-indenting for code paste
vim.keymap.set('n', '<F2>', ':set invpaste paste?<CR>')

-- Change split orientation
vim.keymap.set('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
vim.keymap.set('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')

-- Terminal vim.keymap.setpings
vim.keymap.set('n', '<C-\\>', ':Term<CR>', { noremap = true })      -- open
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')                         -- exit

local vimrc_path = vim.fn.expand("$MYVIMRC")
local parent_path = vim.fn.fnamemodify(vimrc_path, ":h")

-- Edit VimRC
vim.keymap.set('n', '<leader>ev', ':e $MYVIMRC<CR>') -- edit vim
vim.keymap.set('n', '<leader>ek', ':e ' .. parent_path .. '/lua/keymaps.lua<CR>') -- edit vim
vim.keymap.set('n', '<leader>eo', ':e ' .. parent_path .. '/lua/options.lua<CR>') -- edit vim
vim.keymap.set('n', '<leader>ep', ':e ' .. parent_path .. '/lua/plugins.lua<CR>') -- edit vim

-- Zen mode
vim.keymap.set('n', '<leader>z', ':ZenMode<CR>')

-- Window swap
vim.keymap.set('n', '<leader>ws', ':call WindowSwap#EasyWindowSwap()<CR>')


