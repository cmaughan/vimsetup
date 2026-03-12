local conform = require("conform")
local paths = require("util.paths")

-- Vault path for Obsidian - skip format-on-save inside the vault
local vault_path = paths.dropbox_path("Vault") or (vim.fn.stdpath("data") .. "/vault")

conform.setup({
    formatters_by_ft = {
        lua      = { "stylua" },
        python   = { "ruff_format" },
        rust     = { "rustfmt" },
        c        = { "clang_format" },
        cpp      = { "clang_format" },
        h        = { "clang_format" },
        hpp      = { "clang_format" },
        json     = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        sh       = { "shfmt" },
        bash     = { "shfmt" },
        toml     = { "taplo" },
        yaml     = { "prettierd", "prettier" },
    },
    formatters = {
        shfmt = {
            prepend_args = { "-i", "4" },
        },
    },
    format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        -- Skip markdown files inside the Obsidian vault (they have their own conventions)
        if ft == "markdown" then
            local bufpath = vim.api.nvim_buf_get_name(bufnr)
            if bufpath:find(vault_path, 1, true) then
                return nil
            end
        end
        return {
            timeout_ms = 1000,
            lsp_format = "fallback",
        }
    end,
    notify_on_error = true,
})

vim.api.nvim_create_user_command("Format", function(_)
    conform.format({
        async = false,
        lsp_format = "fallback",
    })
end, { bang = true, desc = "Format current buffer" })
