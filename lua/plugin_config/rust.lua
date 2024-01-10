local rt = require("rust-tools")
local mason_registry = require("mason-registry")

local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

local liblldb_path

if vim.loop.os_uname().sysname:find("Windows") then
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
elseif vim.fn.has("mac") == 1 then
    liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
else
    liblldb_path = extension_path .. "lldb/lib/liblldb.so"
end

vim.cmd [[autocmd FileType rust setlocal makeprg=cargo]]

vim.o.updatetime = 200
rt.setup({
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, bufnr)
            vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Gets stuck
            -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            -- vim.keymap.set("n", "ge", function() vim.diagnostic.open_float(nil, {focus = false} ) end)
        end,
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
})

require('dap').configurations.rust = {
    type = "rust"
}



