-----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.opt.mouse = 'a'                       -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard

vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.showmatch = true
vim.opt.foldmethod = 'marker'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.linebreak = true

vim.cmd [[ set noswapfile ]]
vim.cmd [[ set termguicolors ]]

--Line numbers
vim.wo.number = true

vim.g.vimwiki_list = { { path = os.getenv("MYDROPBOX") .. "/vimwiki/" } };

vim.g.windowswap_map_keys = 0;
