require('ufo').setup {
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
}

-- Show fold counts in the fold column
vim.keymap.set('n', 'zR', require('ufo').openAllFolds,  { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })

-- Peek inside a fold without opening it
vim.keymap.set('n', 'zK', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then vim.lsp.buf.hover() end
end, { desc = 'Peek fold' })
