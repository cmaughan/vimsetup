require("onedark").setup({
    -- transparent = false,
    style = 'darker',
})

vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- vim.cmd[[highlight Comment guifg=#444444]]
--vim.cmd[[highlight LspInlayHint guifg=#444444]]
vim.cmd[[highlight @comment guifg=#339933]]

require("ibl").setup({
    scope = {
        enabled = false
    }

})
