require("kanagawa").setup({
    theme = "wave",
    background = {
        dark = "wave",
        light = "lotus",
    },
    colors = {
        theme = {
            wave = {
                ui = {
                    bg = "#0B0F14",
                    bg_gutter = "#0B0F14",
                    bg_m3 = "#11161D",
                    bg_m2 = "#151B22",
                    bg_m1 = "#1A212B",
                    bg_p1 = "#242D39",
                    bg_p2 = "#2B3543",
                },
            },
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            Comment = { fg = theme.syn.comment, italic = true },
            ["@comment"] = { fg = theme.syn.comment, italic = true },
            NormalFloat = { bg = theme.ui.bg_p1 },
            FloatBorder = { bg = theme.ui.bg_p1, fg = theme.ui.special },
            Pmenu = { bg = theme.ui.bg_p1, fg = theme.ui.fg_dim },
            PmenuSel = { bg = theme.ui.bg_m2, fg = theme.ui.fg },
        }
    end,
})

vim.cmd.colorscheme("kanagawa-wave")
vim.o.termguicolors = true

require("ibl").setup({
    scope = {
        enabled = false
    }
})

-- Define Vimwiki highlight groups
vim.api.nvim_set_hl(0, "VimwikiHeader1", { fg = "#7E9CD8", bold = true })
vim.api.nvim_set_hl(0, "VimwikiHeader2", { fg = "#938AA9", bold = true })
vim.api.nvim_set_hl(0, "VimwikiHeader3", { fg = "#957FB8", bold = true })
vim.api.nvim_set_hl(0, "VimwikiLink", { fg = "#7FB4CA", underline = true })
vim.api.nvim_set_hl(0, "VimwikiBold", { fg = "#98BB6C", bold = true })
vim.api.nvim_set_hl(0, "VimwikiItalic", { fg = "#C8C093", italic = true })
vim.api.nvim_set_hl(0, "VimwikiCode", { fg = "#E6C384" })
vim.api.nvim_set_hl(0, "VimwikiList", { fg = "#D27E99" })
