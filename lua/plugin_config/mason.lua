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
})
