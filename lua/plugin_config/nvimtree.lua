--vim.defer_fn(function()
    require('nvim-tree').setup({
        actions = {
            open_file = {
            quit_on_open = true,
            },
        }})
    local function change_root_to_global_cwd()
        local api = require("nvim-tree.api")
        local global_cwd = vim.fn.getcwd(-1, -1)
        api.tree.change_root(global_cwd)
    end

    vim.keymap.set('n', '<leader>jr', change_root_to_global_cwd, { desc = '[J]ump to [R]oot' })
--end, 0)
