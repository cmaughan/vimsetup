
require("onedark").setup({
    --transparent = true,
    style = 'darker',
    colors = { bg0 = '#111111', bg_d = '#111111' },
    highlights = {
        ["@comment"] = { fg = '#339933' },
        ["LspInlayHint"] = { fg = '#444444' },
        -- ["EndOfBuffer"] = { bg = '#101010' },
    }
})

vim.cmd [[colorscheme onedark]]

vim.o.termguicolors = true

-- vim.cmd[[highlight Comment guifg=#444444]]
--vim.cmd[[highlight LspInlayHint guifg=#444444]]
-- vim.cmd[[highlight @comment guifg=#339933]]
-- vim.cmd[[highlight @comment guifg=#339933]]
-- vim.cmd[[highlight Normal guibg=#001111]]
-- vim.cmd[[highlight EndOfBuffer guibg=#001111]]

require("ibl").setup({
    scope = {
        enabled = false
    }

})
