local key = require("util.keymap")
local clangd_build = require("util.clangd_build")

-- Server stderr is classified as an error by Neovim even when it only contains
-- informational progress. Keep the log from growing indefinitely; temporarily
-- switch this back to "WARN" when debugging an LSP problem.
vim.lsp.log.set_level("OFF")

local clangd_root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git',
}

local function clangd_root_dir(bufnr, on_dir)
    local root = vim.fs.root(bufnr, clangd_root_markers)
    if root then
        on_dir(root)
        return
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= '' then
        on_dir(vim.fs.dirname(name))
    end
end

local function clangd_switch_source_header(bufnr, client)
    local method = 'textDocument/switchSourceHeader'

    if not client or not client:supports_method(method) then
        vim.notify(('method %s is not supported by clangd on the current buffer'):format(method), vim.log.levels.WARN)
        return
    end

    local params = vim.lsp.util.make_text_document_params(bufnr)
    client:request(method, params, function(err, result)
        if err then
            vim.notify(tostring(err), vim.log.levels.ERROR)
            return
        end

        if not result then
            vim.notify('corresponding file cannot be determined', vim.log.levels.INFO)
            return
        end

        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local lsp_capabilities = require('blink.cmp').get_lsp_capabilities()

-- Advertise completion support to every server, including servers installed
-- later through Mason.
vim.lsp.config('*', {
    capabilities = lsp_capabilities,
})

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

vim.lsp.config('clangd', {
    root_dir = clangd_root_dir,
    before_init = function(params, config)
        -- clangd 21 deprecated its private offsetEncoding extension in favour
        -- of LSP 3.17's general.positionEncodings, which Neovim advertises.
        params.capabilities.offsetEncoding = nil

        local build = clangd_build.select(config.root_dir)
        clangd_build.notify_once(build)
        if build and build.directory then
            params.initializationOptions = params.initializationOptions or {}
            if params.initializationOptions.compilationDatabasePath == nil then
                params.initializationOptions.compilationDatabasePath = build.directory
            end
        end
    end,
})

local function current_clangd_root()
    local bufnr = vim.api.nvim_get_current_buf()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })) do
        if client.root_dir then
            return client.root_dir
        end
    end

    local root = vim.fs.root(bufnr, clangd_root_markers)
    if root then
        return root
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    return name ~= '' and vim.fs.dirname(name) or nil
end

vim.api.nvim_create_user_command('ClangdBuildInfo', function()
    vim.notify(clangd_build.describe(clangd_build.select(current_clangd_root())), vim.log.levels.INFO)
end, { desc = 'Show clangd compilation database selection' })

vim.api.nvim_create_user_command('ClangdBuildRefresh', function()
    local root = current_clangd_root()
    if not root then
        vim.notify('clangd: no project root found', vim.log.levels.WARN)
        return
    end

    clangd_build.clear(root)
    local selected = clangd_build.select(root)
    clangd_build.notify_once(selected)

    if #vim.lsp.get_clients({ name = 'clangd' }) > 0 then
        vim.cmd('LspRestart clangd')
    end
end, { desc = 'Rescan build directories and restart clangd for this project' })

vim.lsp.config('openscad_lsp', {
    settings = {
        openscad = {
            indent = "    "
        }
    }
});

-- Register all custom configs before enabling servers. Rustaceanvim owns
-- rust-analyzer, and StyLua formatting is handled by conform.nvim.
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "neocmake" },
    automatic_enable = {
        exclude = { "rust_analyzer", "stylua" },
    },
})

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

        key.set('n', 'ge', function() vim.diagnostic.open_float(nil, { focus = false }) end, { buffer = ev.buf, desc = 'LSP: [G]oto [E]rror' })
        key.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'LSP: [G]oto [D]efinitions' })
        key.set('n', 'gD', function() require('telescope.builtin').lsp_type_definitions() end, { buffer = ev.buf, desc = 'LSP: [G]oto Type [D]efinitions' })
        key.set('n', 'gr', function() require('telescope.builtin').lsp_references() end, { buffer = ev.buf, desc = 'LSP: [G]oto [R]eferences' })
        key.set('n', 'gm', function() require('telescope.builtin').lsp_implementations() end, { buffer = ev.buf, desc = 'LSP: [G]oto I[M]plementations' })
        key.set('n', 'gs', function() require('telescope.builtin').lsp_document_symbols() end, { buffer = ev.buf, desc = 'LSP: [G]oto [S]ymbols' })
        key.set('n', 'gS', function() require('telescope.builtin').lsp_workspace_symbols() end, { buffer = ev.buf, desc = 'LSP: [G]oto Workspace [S]ymbols' })
        key.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'LSP: Hover docs' })
        key.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'LSP: [G]oto Signature Docs' })

        key.set('n', '<leader>la', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'LSP: [L]anguage [A]ction' })
        key.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'LSP: [L]anguage [R]ename' })
        key.set('n', '<leader>li', function() require('telescope.builtin').lsp_incoming_calls() end, { buffer = ev.buf, desc = 'LSP: [L]anguage [I]ncoming calls' })
        key.set('n', '<leader>lu', function() require('telescope.builtin').lsp_outgoing_calls() end, { buffer = ev.buf, desc = 'LSP: [L]anguage O[u]tgoing calls' })
        key.set('n', '<leader>lI', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
        end, { buffer = ev.buf, desc = 'LSP: [L]anguage [I]nlay hints toggle' })

        if client and client.name == 'clangd' then
            key.set('n', '<leader>lo', function()
                clangd_switch_source_header(ev.buf, client)
            end, { buffer = ev.buf, desc = 'LSP: [L]anguage [O]ther file' })
        end
    end,
})
