local paths = require("util.paths")

vim.opt.mouse = 'a'                       -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard

vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.autoread = true

vim.opt.scrolloff = 8

-- use spaces for tabs and whatnot
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.fileformats = { "unix", "dos" }
vim.opt.fileformat = "unix"

vim.opt.swapfile = false
vim.opt.backup = false
local undo_dir = paths.dropbox_path(".vim", "undodir") or (vim.fn.stdpath("state") .. "/undo")
vim.opt.undodir = paths.ensure_dir(undo_dir)
vim.opt.undofile = true

-- vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

vim.opt.showmatch = true
-- nvim-ufo handles folding; needs high foldlevel so files open unfolded
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = '1'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.linebreak = true

vim.wo.number = true
vim.opt.relativenumber = true

vim.cmd [[ set noswapfile ]]
vim.cmd [[ set termguicolors ]]

vim.g.windowswap_map_keys = 0;

vim.cmd[[autocmd BufWinEnter,WinEnter term://* startinsert]]

vim.filetype.add({
  pattern = {
    [".*zshrc%.template"]          = "zsh",
    [".*profile%.ps1%.template"]   = "ps1",
    [".*starship%.toml%.template"]  = "toml",
    [".*tmux.*%.conf%.template"]   = "tmux",
  },
})

