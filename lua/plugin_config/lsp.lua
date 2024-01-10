require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd" }
})

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require("lspconfig").rust_analyzer.setup {
    filetypes = { "rust" },
    settings = {
        ['rust-analyzer'] = {
            cargo = { allFeatures = true, }
        }
    }
}

require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
        },
    }
}

require("lspconfig").clangd.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(ev.buf, true)
        end
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'ge', function() vim.diagnostic.open_float(nil, {focus = false} ) end)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>lo', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>ld', vim.diagnostic.setqflist, { silent = true, buffer = true })
        vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, opts)
        vim.keymap.set('n', '<leader>ko', ':ClangdSwitchSourceHeader<CR>')
    end,
})
