require("catppuccin").setup({
    flavour = "mocha",
    term_colors = true,
    color_overrides = {
        mocha = {
            base = "#080A0F",
            mantle = "#06080C",
            crust = "#040509",
        },
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        indent_blankline = {
            enabled = true,
            scope_color = "",
            colored_indent_levels = false,
        },
        mason = true,
        mini = true,
        telescope = true,
        treesitter = true,
        which_key = true,
    },
    custom_highlights = function(colors)
        return {
            ["@comment"] = { fg = colors.green },
        }
    end,
})

vim.cmd.colorscheme("catppuccin")
vim.o.termguicolors = true

require("ibl").setup({
    scope = {
        enabled = false
    }
})

-- Define Vimwiki highlight groups
vim.api.nvim_set_hl(0, "VimwikiHeader1", { fg = "#89B4FA", bold = true })
vim.api.nvim_set_hl(0, "VimwikiHeader2", { fg = "#B4BEFE", bold = true })
vim.api.nvim_set_hl(0, "VimwikiHeader3", { fg = "#CBA6F7", bold = true })
vim.api.nvim_set_hl(0, "VimwikiLink", { fg = "#74C7EC", underline = true })
vim.api.nvim_set_hl(0, "VimwikiBold", { fg = "#A6E3A1", bold = true })
vim.api.nvim_set_hl(0, "VimwikiItalic", { fg = "#BAC2DE", italic = true })
vim.api.nvim_set_hl(0, "VimwikiCode", { fg = "#F9E2AF" })
vim.api.nvim_set_hl(0, "VimwikiList", { fg = "#F5C2E7" })
