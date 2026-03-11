vim.o.termguicolors = true

require("nightfox").setup({
    options = {
        styles = {
            comments = "italic",
        },
    },
    groups = {
        all = {
            NormalFloat = { bg = "palette.bg0" },
            FloatBorder = { bg = "palette.bg0", fg = "palette.bg4" },
            Pmenu = { bg = "palette.bg0", fg = "palette.fg2" },
            PmenuSel = { bg = "palette.sel0", fg = "palette.fg1" },
        },
    },
})

vim.cmd.colorscheme("carbonfox")

require("ibl").setup({
    scope = {
        enabled = false,
    },
})

local function set_custom_highlights()
  vim.api.nvim_set_hl(0, "VimwikiHeader1", { fg = "#78A9FF", bold = true })
  vim.api.nvim_set_hl(0, "VimwikiHeader2", { fg = "#BE95FF", bold = true })
  vim.api.nvim_set_hl(0, "VimwikiHeader3", { fg = "#FF7EB6", bold = true })
  vim.api.nvim_set_hl(0, "VimwikiLink",    { fg = "#33B1FF", underline = true })
  vim.api.nvim_set_hl(0, "VimwikiBold",    { fg = "#25BE6A", bold = true })
  vim.api.nvim_set_hl(0, "VimwikiItalic",  { fg = "#3DDBD9", italic = true })
  vim.api.nvim_set_hl(0, "VimwikiCode",    { fg = "#08BDBA" })
  vim.api.nvim_set_hl(0, "VimwikiList",    { fg = "#EE5396" })
end

set_custom_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_custom_highlights })
