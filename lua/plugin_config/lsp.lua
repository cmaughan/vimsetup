local key = require("util.keymap")

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

vim.lsp.config('lua_ls', {
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
})

vim.lsp.config('clangd', {})

vim.lsp.config('openscad_lsp', {
    settings = {
        openscad = {
            indent = "    "
        }
    }
});

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf})
        end

        local telescope = require('telescope.builtin')

        key.set('n', 'ge', function() vim.diagnostic.open_float(nil, { focus = false }) end, { buffer = ev.buf, desc = 'LSP: [G]oto [E]rror' })
        key.set('n', 'gd', telescope.lsp_definitions, { buffer = ev.buf, desc = 'LSP: [G]oto [D]efinitions' })
        key.set('n', 'gD', telescope.lsp_type_definitions, { buffer = ev.buf, desc = 'LSP: [G]oto Type [D]efinitions' })
        key.set('n', 'gr', telescope.lsp_references, { buffer = ev.buf, desc = 'LSP: [G]oto [R]eferences' })
        key.set('n', 'gm', telescope.lsp_implementations, { buffer = ev.buf, desc = 'LSP: [G]oto I[M]plementations' })
        key.set('n', 'gs', telescope.lsp_document_symbols, { buffer = ev.buf, desc = 'LSP: [G]oto [S]ymbols' })
        key.set('n', 'gS', telescope.lsp_workspace_symbols, { buffer = ev.buf, desc = 'LSP: [G]oto Workspace [S]ymbols' })
        key.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'LSP: Hover docs' })
        key.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'LSP: [G]oto Signature Docs' })

        key.set('n', '<leader>la', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'LSP: [L]anguage [A]ction' })
        key.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'LSP: [L]anguage [R]ename' })
        key.set('n', '<leader>li', telescope.lsp_incoming_calls, { buffer = ev.buf, desc = 'LSP: [L]anguage [I]ncoming calls' })
        key.set('n', '<leader>lu', telescope.lsp_outgoing_calls, { buffer = ev.buf, desc = 'LSP: [L]anguage O[u]tgoing calls' })

        if client and client.name == 'clangd' then
            key.set('n', '<leader>lo', function()
                vim.cmd.ClangdSwitchSourceHeader()
            end, { buffer = ev.buf, desc = 'LSP: [L]anguage [O]ther file' })
        end
    end,
})
