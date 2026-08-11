local paths = require("util.paths")

local vault_path = paths.dropbox_path("Vault")
if not vault_path or vim.fn.isdirectory(vault_path) == 0 then
    return
end

require("obsidian").setup({
    legacy_commands = false,

    workspaces = {
        { name = "vault", path = vault_path },
    },

    -- Use Telescope for search/picker
    picker = { name = "telescope.nvim" },

    -- Completion for wiki links and tags comes from the built-in obsidian-ls.
    completion = {
        min_chars = 2,
    },

    -- Daily notes
    daily_notes = {
        folder = "Daily",
        date_format = "%Y-%m-%d",
    },

    ui = {
        -- render-markdown.nvim handles markdown decoration.
        enable = false,
    },
})
