vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local paths = require("util.paths")

-- I'd really like this, but doesn't play nice with make
-- vim.o.shell = "pwsh.exe"

if vim.fn.has('win32') == 1 then
  local pyenv_python = vim.fn.expand('~/.pyenv/pyenv-win/versions/3.12.9/python.exe')
  local fallback_python = vim.fn.exepath('python')
  if vim.loop.fs_stat(pyenv_python) then
    vim.g.python3_host_prog = pyenv_python
  else
    vim.g.python3_host_prog = fallback_python
  end
else
  vim.g.python3_host_prog = vim.fn.exepath('python3')
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_bootstrap = not vim.loop.fs_stat(lazypath)
if lazy_bootstrap then
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
require("plugin_config/pre-init")
require("plugins")
require("keymaps")
require("plugin_config.quickfix")
require("session").setup()

if lazy_bootstrap then
  require("lazy").sync()
end

vim.api.nvim_create_user_command("ClearShada", function()
        local shada_path = vim.fn.expand(vim.fn.stdpath('data') .. "/shada")
        local files = vim.fn.glob(shada_path .. "/*", false, true)
        local all_success = 0
        for _, file in ipairs(files) do
            local file_name = vim.fn.fnamemodify(file, ":t")
            if file_name == "main.shada" then
                -- skip your main.shada file
                goto continue
            end
            local success = vim.fn.delete(file)
            all_success = all_success + success
            if success ~= 0 then
                vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
            end
            ::continue::
        end
        if all_success == 0 then
            vim.print("Successfully deleted all temporary shada files")
        end
    end,
    { desc = "Clears all the .tmp shada files" }
)
