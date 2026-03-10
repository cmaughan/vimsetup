local paths = require("util.paths")
local neorg_home = paths.ensure_dir(paths.dropbox_path("neorg") or (vim.fn.stdpath("data") .. "/neorg"))

require('neorg').setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    home = neorg_home
                },
                default_workspace = 'home',
            }
        }
    }
})
