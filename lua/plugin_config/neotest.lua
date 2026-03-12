local key = require("util.keymap")

vim.g["test#strategy"] = "basic"

require("neotest").setup({
  adapters = {
    require("neotest-vim-test")({
      ignore_file_types = { "vimwiki" },
    }),
  },
})

key.set('n', '<leader>to', function() require("neotest").output.open({ enter = true }) end, { desc = '[T]est [O]utput' })
key.set('n', '<leader>ts', function() require("neotest").summary.toggle() end,              { desc = '[T]est [S]ummary toggle' })
