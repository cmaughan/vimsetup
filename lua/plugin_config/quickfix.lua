vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    callback = function()
        if vim.fn.empty(vim.fn.filter(vim.fn.getqflist(), 'v:val.valid')) == 1 then
            vim.api.nvim_command('cclose')
        end
    end
})
