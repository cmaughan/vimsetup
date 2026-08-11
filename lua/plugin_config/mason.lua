require("mason").setup()

require("mason-tool-installer").setup({
    ensure_installed = {
        "clang-format",
        "jsonlint",
        "markdownlint",
        "prettierd",
        "ruff",
        "shfmt",
        "shellcheck",
        "stylua",
        "taplo",
        "yamllint",
    },
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 24,
    -- Every entry above is already a Mason package name. Avoid probing optional
    -- integrations here: the DAP probe otherwise loads the entire debugger on
    -- the first file open.
    integrations = {
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
    },
})
