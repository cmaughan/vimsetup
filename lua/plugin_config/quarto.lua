require("quarto").setup({
    lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash", "lua", "html", "css" },
        chunks = "curly",
        diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
        },
        completion = {
            enabled = true,
        },
    },
    codeRunner = {
        enabled = false,
    },
})
