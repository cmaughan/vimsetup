local rt = require('rust-tools')
local mason_registry = require('mason-registry')

local codelldb = mason_registry.get_package('codelldb')
local extension_path = codelldb:get_install_path() .. '/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'

local liblldb_path

if vim.loop.os_uname().sysname:find('Windows') then
    liblldb_path = extension_path .. 'lldb\\bin\\liblldb.dll'
elseif vim.fn.has('mac') == 1 then
    liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
else
    liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
end

vim.cmd [[autocmd FileType rust setlocal makeprg=cargo]]

vim.o.updatetime = 200
rt.setup({
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        -- adapter = {
        --     type = 'server',
        --     port = '${port}',
        --     host = '127.0.0.1',
        --     name = 'codelldb',
        --     executable = {
        --         command = codelldb_path,
        --         args = { '--liblldb', liblldb_path, '--port', '${port}' },
        --     },
        -- }
    },
    server = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function(_, bufnr)
            vim.keymap.set('n', '<Leader>k', rt.hover_actions.hover_actions,
                { buffer = bufnr, desc = 'Rust hover actions' })
        end,
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
})

require('dap').configurations.rust = {
    {
        name = 'Launch default executable',
        type = 'rt_lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        -- program = function()
        --     vim.fn.jobstart('cargo build')
        --     local execute = require('qss_nvim.utils').execute_and_capture_output
        --     local output = execute('find target/debug -name $(basename $(pwd))')
        --     print(output)
        --     return output
        -- end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        showDisassembly = 'never',
        terminal = 'integrated',
        sourceLanguages = { 'rust' }
    }
}
