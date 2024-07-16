require('neorg').setup({
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    home = os.getenv("MYDROPBOX") .. "/neorg"
                },
                default_workspace = "home"
            }
        }
    }
})
