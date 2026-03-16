local paths = require("util.paths")

local vault_path = paths.dropbox_path("Vault")
if not vault_path or vim.fn.isdirectory(vault_path) == 0 then
    return
end

require("obsidian").setup({
    workspaces = {
        { name = "vault", path = vault_path },
    },

    -- Use Telescope for search/picker
    picker = { name = "telescope.nvim" },

    -- Follow markdown links with gf
    follow_url_func = function(url)
        vim.fn.jobstart({ "cmd", "/c", "start", url })
    end,

    -- Don't use obsidian.nvim's own completion (use nvim-cmp via its source instead)
    completion = {
        nvim_cmp = true,
        min_chars = 2,
    },

    -- Daily notes
    daily_notes = {
        folder = "Daily",
        date_format = "%Y-%m-%d",
    },

    ui = {
        -- Disable if you find it conflicts with other plugins
        enable = true,
    },
})
