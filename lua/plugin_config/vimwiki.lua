local paths = require("util.paths")

local vimwiki_path = paths.ensure_dir(paths.dropbox_path("vimwiki") or (vim.fn.stdpath("data") .. "/vimwiki"))

vim.g.vimwiki_list = {
  { path = vimwiki_path .. "/" },
}

-- Set colorscheme (optional, ensure this is compatible with your setup)
