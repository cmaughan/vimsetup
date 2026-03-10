local lint = require("lint")

lint.linters_by_ft = {
    bash = { "shellcheck" },
    json = { "jsonlint" },
    markdown = { "markdownlint" },
    python = { "ruff" },
    sh = { "shellcheck" },
    yaml = { "yamllint" },
}

local function available_linters(bufnr)
    local filetype = vim.bo[bufnr].filetype
    local names = lint.linters_by_ft[filetype] or {}

    return vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
            return false
        end

        local cmd = linter.cmd
        if type(cmd) == "function" then
            local ok, resolved = pcall(cmd)
            cmd = ok and resolved or nil
        end

        return type(cmd) == "string" and vim.fn.executable(cmd) == 1
    end, names)
end

local function lint_buffer(bufnr)
    local names = available_linters(bufnr)
    if #names == 0 then
        return
    end

    lint.try_lint(names)
end

local group = vim.api.nvim_create_augroup("UserLinting", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = group,
    callback = function(args)
        lint_buffer(args.buf)
    end,
})

vim.api.nvim_create_user_command("Lint", function()
    lint_buffer(vim.api.nvim_get_current_buf())
end, { desc = "Lint current buffer" })
