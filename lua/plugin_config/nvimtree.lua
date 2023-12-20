require("nvim-tree").setup({
    filters = {
        dotfiles = true,
    }
})

vim.keymap.set('n', '<c-t>', ':NvimTreeToggle<CR>')
