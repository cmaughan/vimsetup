vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local paths = require("util.paths")

-- I'd really like this, but doesn't play nice with make
-- vim.o.shell = "pwsh.exe"

local python_host_prog = paths.resolve_python_host_prog()
if python_host_prog then
  vim.g.python3_host_prog = python_host_prog
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
require("plugin_config")
require("keymaps")

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
