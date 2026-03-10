local rust_analyzer_target_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "rust-analyzer")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.makeprg = "cargo"
  end,
})

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          extraArgs = { "--target-dir", rust_analyzer_target_dir },
        },
      },
    },
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<leader>k", function()
        vim.cmd("RustLsp hover actions")
      end, { buffer = bufnr, desc = "Rust hover actions" })
    end,
  },
}
