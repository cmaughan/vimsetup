require("onedark").setup({
    -- transparent = false,
    style = 'darker'
})

vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

require("ibl").setup({
    scope = {
        enabled = false
    }

})
