local paths = require("util.paths")

local scratch_dir = paths.dropbox_path(".vim", "scratch-files") or (vim.fn.stdpath("data") .. "/scratch-files")
paths.ensure_dir(scratch_dir)

require('scratch').setup({
    scratch_file_dir = scratch_dir,
})
