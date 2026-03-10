local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        h = { "clang_format" },
        hpp = { "clang_format" },
        json = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        toml = { "taplo" },
        yaml = { "prettierd", "prettier" },
    },
    formatters = {
        shfmt = {
            prepend_args = { "-i", "4" },
        },
    },
    format_on_save = function(bufnr)
        local ignored = {
            markdown = true,
        }

        if ignored[vim.bo[bufnr].filetype] then
            return nil
        end

        return {
            timeout_ms = 1000,
            lsp_format = "fallback",
        }
    end,
    notify_on_error = true,
})

vim.api.nvim_create_user_command("Format", function(args)
    conform.format({
        async = false,
        lsp_format = "fallback",
    })
end, { bang = true, desc = "Format current buffer" })
