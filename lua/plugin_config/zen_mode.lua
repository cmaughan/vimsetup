require("zen-mode").setup({
    window = {
        backdrop = 0.9,
        width = .95,
        options = {
            number = true,
            relativenumber = true,
            signcolumn = 'no',
            list = false,
        },
    },
    plugins = {
        gitsigns = { enabled = false },
        twilight = { enabled = false }
    }

})
