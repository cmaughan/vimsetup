local paths = require("util.paths")

local scratch_file = paths.dropbox_path(".vim", "scratch") or (vim.fn.stdpath("data") .. "/scratch")
paths.ensure_dir(vim.fn.fnamemodify(scratch_file, ":h"))
vim.g.scratch_persistence_file = scratch_file
