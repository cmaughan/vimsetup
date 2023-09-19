--[[

Neovim init file
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua

--]]

vim.g.python3_host_prog = 'C:/Users/cmaughan/.pyenv/pyenv-win/versions/3.10.4/python.exe'

-- Import Lua modules
require('packer_init')
require('core/options')
require('core/autocmds')
require('core/keymaps')
require('core/colors')
require('core/statusline')
-- require('lsp/lspconfig')
require('plugins/nvim-tree')
require('plugins/indent-blankline')
require('plugins/nvim-cmp')
-- require('plugins/nvim-treesitter')
require('plugins/alpha-nvim')
require('plugins/vim-telescope')
require('plugins/vimwiki')
require('plugins/scratch')
