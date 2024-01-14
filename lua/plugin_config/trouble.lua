vim.keymap.set('n', '<leader>tx', function() require('trouble').toggle() end)
vim.keymap.set('n', '<leader>tr', function() require('trouble').toggle("lsp_references") end)
vim.keymap.set('n', '<leader>tq', function() require('trouble').toggle("quickfix") end)
vim.keymap.set('n', '<leader>tl', function() require('trouble').toggle("loclist") end)
vim.keymap.set('n', '<leader>tw', function() require('trouble').toggle("workspace_diagnostics") end)
vim.keymap.set('n', '<leader>td', function() require('trouble').toggle("document_diagnostics") end)

-- ensure window is open and hop to errors
vim.keymap.set('n', '<F8>', function()
    local t = require('trouble')
    t.open()
    t.next({skip_gropus=true, jump=true})
end)

vim.keymap.set('n', '<S-F8>', function()
    require('trouble').previous({skip_groups=true, jump=true})
end)

require("trouble").setup({
    auto_open = false,
    auto_close = true,
    auto_fold = false
})

