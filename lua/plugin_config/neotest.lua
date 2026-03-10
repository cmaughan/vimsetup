vim.g["test#strategy"] = "basic"

require("neotest").setup({
  adapters = {
    require("neotest-vim-test")({
      ignore_file_types = { "vimwiki" },
    }),
  },
})
