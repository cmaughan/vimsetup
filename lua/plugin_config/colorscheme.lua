
require("onedark").setup({
    --transparent = true,
    style = 'darker',
    colors = { bg0 = '#191919', bg_d = '#191919' },
    highlights = {
        ["@comment"] = { fg = '#339933' },
        -- ["LspInlayHint"] = { fg = '#222222' },
        -- ["EndOfBuffer"] = { bg = '#101010' },
    }
})

vim.cmd [[colorscheme onedark]]

vim.o.termguicolors = true


require("ibl").setup({
    scope = {
        enabled = false
    }

})

-- Define Vimwiki highlight groups
vim.api.nvim_set_hl(0, 'VimwikiHeader1', { fg = '#6a5acd', bold = true }) -- pastel dark blue
vim.api.nvim_set_hl(0, 'VimwikiHeader2', { fg = '#7b68ee', bold = true }) -- medium slate blue
vim.api.nvim_set_hl(0, 'VimwikiHeader3', { fg = '#9370db', bold = true }) -- medium purple
vim.api.nvim_set_hl(0, 'VimwikiLink', { fg = '#4682b4', underline = true }) -- steel blue
vim.api.nvim_set_hl(0, 'VimwikiBold', { fg = '#2f4f4f', bold = true }) -- dark slate gray
vim.api.nvim_set_hl(0, 'VimwikiItalic', { fg = '#708090', italic = true }) -- slate gray
vim.api.nvim_set_hl(0, 'VimwikiCode', { fg = '#556b2f' }) -- dark olive green
vim.api.nvim_set_hl(0, 'VimwikiList', { fg = '#8b4513' }) -- saddle brown

