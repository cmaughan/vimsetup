require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<Leader>dx", ':DapTerminate<CR>')

vim.keymap.set("n", "<c-i>", ':DapToggleBreakpoint<CR>')
vim.keymap.set('n', '<F5>', ':DapContinue')
vim.keymap.set("n", "<F10>do", ':DapStepOver<CR>')
vim.keymap.set("n", "<F11>do", ':DapStepInto<CR>')

vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

require('dap').configurations.rust = {
    type = "rust"
}
