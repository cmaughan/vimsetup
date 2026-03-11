local paths = require("util.paths")

local vault_path = paths.dropbox_path("Vault") or (vim.fn.stdpath("data") .. "/vault")

require("obsidian").setup({
    workspaces = {
        { name = "vault", path = vault_path },
    },

    -- Use Telescope for search/picker
    picker = { name = "telescope" },

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
