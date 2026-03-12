local dap = require('dap')
local dapui = require('dapui')

-- Auto open/close UI on debug session events
dap.listeners.after.event_initialized['dapui_config']  = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config']  = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config']      = function() dapui.close() end

dapui.setup({
    icons = { expanded = '▾', collapsed = '▸', current_frame = '▶' },
    layouts = {
        {
            elements = {
                { id = 'scopes',      size = 0.35 },
                { id = 'breakpoints', size = 0.15 },
                { id = 'stacks',      size = 0.30 },
                { id = 'watches',     size = 0.20 },
            },
            size = 45,
            position = 'left',
        },
        {
            elements = {
                { id = 'repl',    size = 0.5 },
                { id = 'console', size = 0.5 },
            },
            size = 12,
            position = 'bottom',
        },
    },
})

-- Breakpoint signs
vim.fn.sign_define('DapBreakpoint',          { text = '●', texthl = 'DiagnosticError',   numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarning', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected',  { text = '○', texthl = 'DiagnosticError',   numhl = '' })
vim.fn.sign_define('DapStopped',             { text = '▶', texthl = 'DiagnosticOk',      linehl = 'DapStoppedLine', numhl = '' })
vim.fn.sign_define('DapLogPoint',            { text = '◉', texthl = 'DiagnosticInfo',    numhl = '' })

-- C / C++ / Rust launch configurations via codelldb
-- mason-nvim-dap with handlers={} auto-registers the codelldb adapter,
-- so we only need to define launch configurations here.
local cpp_config = {
    {
        name    = 'Launch executable (ask)',
        type    = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd          = '${workspaceFolder}',
        stopOnEntry  = false,
        args         = {},
    },
    {
        name    = 'Launch executable with args',
        type    = 'codelldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
            local args_str = vim.fn.input('Arguments: ')
            return vim.split(args_str, ' ', { trimempty = true })
        end,
        cwd         = '${workspaceFolder}',
        stopOnEntry = false,
    },
    {
        name      = 'Attach to process',
        type      = 'codelldb',
        request   = 'attach',
        pid       = require('dap.utils').pick_process,
        args      = {},
    },
}

dap.configurations.c   = cpp_config
dap.configurations.cpp = cpp_config
dap.configurations.rust = cpp_config
