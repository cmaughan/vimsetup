require("oil").setup({
    default_file_explorer = false
})
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
