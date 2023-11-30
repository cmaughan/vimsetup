require('neorg').setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    home = os.getenv("MYDROPBOX") .. "/neorg"
                },
                default_workspace = "home"
            }
        }
    }
})
