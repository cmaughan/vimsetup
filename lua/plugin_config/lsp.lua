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

        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
        end

        nmap('ge', function() vim.diagnostic.open_float(nil, { focus = false }) end, '[G]oto [E]rror')

        local telescope = require('telescope.builtin')
        nmap('gs', telescope.lsp_dynamic_workspace_symbols, '[G]oto [S]ymbols')
        nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinitions')
        nmap('gD', telescope.lsp_type_definitions, '[G]oto Type [D]efinitions')
        nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
        nmap('gm', telescope.lsp_implementations, '[G]oto I[M]plementations')
        nmap('gi', telescope.lsp_incoming_calls, '[G]oto [I]ncoming')
        nmap('gu', telescope.lsp_outgoing_calls, '[G]oto O[u]tgoing')

        nmap('<leader>ws', telescope.lsp_workspace_symbols, '[G]oto [W]ork Symbols')
        nmap('<leader>ds', telescope.lsp_document_symbols, '[G]oto Doc [S]ymbols')

        nmap('<leader>gf', vim.diagnostic.open_float, '[G]oto [F]loat')

        nmap('K', vim.lsp.buf.hover, 'Hover Docs')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Docs')

        nmap('<leader>K', vim.lsp.buf.hover, '[K] hover')
        nmap('<space>wa', vim.lsp.buf.add_workspace_folder, 'Add [W]ork Folder')
        nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, 'Remove [W]ork Folder')
        nmap('<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'List [W]ork Folders')
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        vim.keymap.set('n', '<leader>ld', vim.diagnostic.setqflist, { silent = true, buffer = true })
        nmap('<leader>lf', function() vim.lsp.buf.format { async = true } end, '[L]sp Format')
    end,
})
