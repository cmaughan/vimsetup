vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- I'd really like this, but doesn't play nice with make
-- vim.o.shell = "pwsh.exe"

vim.g.python3_host_prog = 'C:/Users/cmaughan/.pyenv/pyenv-win/versions/3.10.4/python.exe'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")
require("plugins")
require("plugin_config")
