require("auto-session").setup {
    pre_save_cmds = { "NvimTreeClose" },
    save_extra_cmds = { "NvimTreeOpen" },
    post_restore_cmds = { "NvimTreeOpen" }
}
