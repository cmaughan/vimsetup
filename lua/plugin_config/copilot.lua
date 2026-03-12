vim.cmd[[highlight CopilotSuggestion ctermfg=8 guifg=white guibg=#5c6370]]

require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
})
require("copilot_cmp").setup()
