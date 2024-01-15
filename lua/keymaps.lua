local vimrc_path = vim.fn.expand("$MYVIMRC")
local parent_path = vim.fn.fnamemodify(vimrc_path, ":h")
local key = vim.keymap

-- Esc --
key.set('i', 'jk', '<ESC>', { desc = '[j][k] Escape' })
key.set('t', 'jk', [[<C-\><C-n>]], { desc = '[j][k] Escape' })

-- Tree
key.set('n', '<c-t>', ':NvimTreeToggle<CR>')

-- Oil
key.set('n', '-', require("oil").open, { desc = "Open parent directory" })

-- Telescope
local telescope = require('telescope.builtin')
key.set('n', '<c-p>', telescope.find_files, {})
key.set('n', '<c-,>', telescope.find_files, {})
key.set('n', '<leader>?', telescope.oldfiles, { desc = '[?] Find recently opened files' })
key.set('n', '<leader><space>', telescope.buffers, { desc = '[ ] Find existing buffers' })
key.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' }
)
key.set('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind [G]rep' })
key.set('n', '<leader>fb', telescope.buffers, { desc = '[F]ind [B]uffers' })
key.set('n', '<leader>fh', telescope.help_tags, { desc = '[F]ind [h]elp tags' })
key.set('n', '<leader>fH', telescope.help_tags, { desc = '[F]ind [H]elp' })
key.set('n', '<leader>fi', telescope.git_files, { desc = '[F]ind G[i]t files' })
key.set('n', '<leader>fw', telescope.grep_string, { desc = '[F]ind current [W]ord' })
key.set('n', '<leader>fd', telescope.diagnostics, { desc = '[F]ind [D]iagnostics' })
key.set('n', '<leader>fa', telescope.resume, { desc = '[F]ind [A]again' })
key.set('n', '<leader>fs', telescope.builtin, { desc = '[F]ind [S]elect Telescope' })
key.set('n', '<leader>fm', function() telescope.treesitter({ default_text = ":method:" }) end)

-- Wiki
key.set('n', '<leader>ww', ':Neorg index<CR>', { desc = '[W]iki [W]iki' })

-- Harpoon
local harpoon = require("harpoon.ui")
key.set("n", "<leader>ha", require("harpoon.mark").add_file, { desc = '[H]arpoon [A]dd' })
key.set("n", "<leader>hh", harpoon.toggle_quick_menu, { desc = '[H]arpoon [H]arpoon' })
key.set("n", "<leader>h1", function() harpoon.nav_file(1) end, { desc = '[H]arpoon [1]' })
key.set("n", "<leader>h2", function() harpoon.nav_file(2) end, { desc = '[H]arpoon [2]' })
key.set("n", "<leader>h3", function() harpoon.nav_file(3) end, { desc = '[H]arpoon [3]' })
key.set("n", "<leader>h4", function() harpoon.nav_file(4) end, { desc = '[H]arpoon [4]' })
key.set("n", "<leader>h5", function() harpoon.nav_file(5) end, { desc = '[H]arpoon [5]' })
key.set("n", "<leader>h6", function() harpoon.nav_file(6) end, { desc = '[H]arpoon [6]' })
key.set("n", "<leader>h7", function() harpoon.nav_file(7) end, { desc = '[H]arpoon [7]' })
key.set("n", "<leader>h8", function() harpoon.nav_file(8) end, { desc = '[H]arpoon [8]' })
key.set("n", "<leader>h9", function() harpoon.nav_file(9) end, { desc = '[H]arpoon [9]' })

-- Zen mode
key.set('n', '<leader>z', ':ZenMode<CR>', { desc = '[Z]en mode' })

-- Window swap
key.set('n', '<leader>ws', ':call WindowSwap#EasyWindowSwap()<CR>', { desc = '[W]indow [S]wap' })

-- Terminal key.setpings
key.set('n', '<C-\\>', ':Term<CR>', { noremap = true, desc = '' }) -- open
key.set('t', '<Esc>', '<C-\\><C-n>', { desc = '' })                -- exit

-- Navigate vim panes better
key.set('n', '<c-k>', ':wincmd k<CR>', { desc = '' })
key.set('n', '<c-j>', ':wincmd j<CR>', { desc = '' })
key.set('n', '<c-h>', ':wincmd h<CR>', { desc = '' })
key.set('n', '<c-l>', ':wincmd l<CR>', { desc = '' })

key.set('n', '<c-left>', 'gt', { desc = '' })
key.set('n', '<c-right>', 'gT', { desc = '' })

key.set('t', '<c-k>', '<C-\\><C-n> :wincmd k<CR>', { desc = '' })
key.set('t', '<c-j>', '<C-\\><C-n> :wincmd j<CR>', { desc = '' })
key.set('t', '<c-h>', '<C-\\><C-n> :wincmd h<CR>', { desc = '' })
key.set('t', '<c-l>', '<C-\\><C-n> :wincmd l<CR>', { desc = '' })

key.set('n', 'j', 'gj', { desc = '[<J>] down' })
key.set('n', 'k', 'gk', { desc = '[<K>] up' })
key.set('n', 'gj', 'j', { desc = '[<gj>] <j>' })
key.set('n', 'gk', 'k', { desc = '[<gk>] <k>' })
key.set('n', '<c-l>', ':wincmd l<CR>', { desc = '' })

-- Move visual selection up and down
key.set('v', 'K', ':m \'<-2<CR>gv=gv', { desc = '[<K>] Visual up' })
key.set('v', 'J', ':m \'>+1<CR>gv=gv', { desc = '[<J>] Visual down' })

-- Append to line, keep cursor at beginning
key.set('n', 'J', 'mzJ`z', { desc = '[<J>] Append to line' })

-- Keep cursor in middle while going up/down
key.set('n', '<c-d>', "<c-d>zz", { desc = '' })
key.set('n', '<c-u>', "<c-u>zz", { desc = '' })
key.set('n', '<c-f>', "<c-f>zz", { desc = '' })
key.set('n', '<c-b>', "<c-b>zz", { desc = '' })

key.set('n', 'n', 'nzzzv', { desc = '' })
key.set('n', 'N', 'Nzzzv', { desc = '' })

-- Ignore this
key.set('n', 'Q', "<nop>", { desc = '' })

-- Ignore arrows
key.set('', '<up>', '<nop>', { desc = '' })
key.set('', '<down>', '<nop>', { desc = '' })
key.set('', '<left>', '<nop>', { desc = '' })
key.set('', '<right>', '<nop>', { desc = '' })

-- Paste over and keep selection
key.set('x', '<leader>p', '\"_dP', { desc = '' })

-- Clear search highlighting with <leader> and c
key.set('n', '<leader>cs', ':nohl<CR>', { desc = '[C]lear [S]earch' })

-- Toggle auto-indenting for code paste
key.set('n', '<F2>', ':set invpaste paste?<CR>', { desc = '' })

-- Hopword
key.set('n', '<leader>fh', ':HopWord<CR>', { desc = '[F]ind [H]op' })

-- Split window management
key.set('n', '<leader>sv', '<C-w>v', { desc = '[S]plit [V]ertical' })
key.set('n', '<leader>sh', '<C-w>s', { desc = '[S]plit [H]orizontal' })
key.set('n', '<leader>se', '<C-w>=', { desc = '[S]plit [E]qual' })
key.set('n', '<leader>sx', ':close<CR>', { desc = '[S]plit E[X]it' })
key.set('n', '<leader>sj', '<C-w>-', { desc = '[S]plit [<j>] shorter' })
key.set('n', '<leader>sk', '<C-w>+', { desc = '[S]plit [<k>] taller' })
key.set('n', '<leader>sl', '<C-w>>5', { desc = '[S]plit [<l>] larger' })
key.set('n', '<leader>sh', '<C-w><5', { desc = '[S]plit [<h>] smaller' })
key.set('n', '<leader>vh', '<C-w>t<C-w>K', { desc = '[V]ertical to [H]orizontal' })
key.set('n', '<leader>hv', '<C-w>t<C-w>H', { desc = '[H]orizontal to [V]ertical' })

-- Move around splits using Ctrl + {h,j,k,l}
key.set('', '<C-h>', '<C-w>h', { desc = '' })
key.set('', '<C-j>', '<C-w>j', { desc = '' })
key.set('', '<C-k>', '<C-w>k', { desc = '' })
key.set('', '<C-l>', '<C-w>l', { desc = '' })

key.set('n', '<leader>oc', ':nohlsearch<CR>', { desc = 'T[O]ggle search [C]lear' })
key.set('n', '<leader>go', ':ClangdSwitchSourceHeader<CR>', { desc = '[G]o [O]ther' })
key.set('n', '<leader>ko', ':ClangdSwitchSourceHeader<CR>', { desc = '[K] Go [O]ther' })

-- Edit VimRC
key.set('n', '<leader>ev', ':e $MYVIMRC<CR>', { desc = '[E]dit V[imrc' })
key.set('n', '<leader>ek', ':e ' .. parent_path .. '/lua/keymaps.lua<CR>', { desc = '[E]dit [K]eymaps' })
key.set('n', '<leader>eo', ':e ' .. parent_path .. '/lua/options.lua<CR>', { desc = '[E]dit [O]ptions' })
key.set('n', '<leader>ep', ':e ' .. parent_path .. '/lua/plugins.lua<CR>', { desc = '[E]dit [P]lugins' })
key.set('n', '<leader>ec', ':e ' .. parent_path .. '/lua/plugin_config<CR>', { desc = '[E]edit [C]onfig folder' })

-- Dap
key.set("n", "<Leader>dx", ':DapTerminate<CR>', { desc = '[D]ebug E[x]it' })
key.set("n", "<Leader>db", ':DapToggleBreakpoint<CR>', { desc = '[D]ebug [B]readkpoint' })
key.set('n', '<F5>', ':DapContinue<CR>', { desc = '' })
key.set("n", "<F10>", ':DapStepOver<CR>', { desc = '' })
key.set("n", "<F11>", ':DapStepInto<CR>', { desc = '' })

-- Trouble
local trouble = require('trouble')
key.set('n', '<leader>tx', function() trouble.toggle() end, { desc = '[T]rouble E[x]it' })
key.set('n', '<leader>tr', function() trouble.toggle("lsp_references") end, { desc = '[T]rouble [R]eferences' })
key.set('n', '<leader>tq', function() trouble.toggle("quickfix") end, { desc = '[T]rouble [Q]uickfix' })
key.set('n', '<leader>tl', function() trouble.toggle("loclist") end, { desc = '[T]rouble [L]ocal list' })
key.set('n', '<leader>tw', function() trouble.toggle("workspace_diagnostics") end,
    { desc = '[T]rouble [W]orkspace diag' })
key.set('n', '<leader>td', function() trouble.toggle("document_diagnostics") end,
    { desc = '[T]rouble [D]oc Diagnostics' })
key.set('n', '<F8>', function()
    trouble.open()
    trouble.next({ skip_gropus = true, jump = true })
end, { desc = '[<F8>]Trouble Next' })

key.set('n', '<S-F8>', function()
    trouble.previous({ skip_groups = true, jump = true })
end, { desc = '[<S-F8>]Trouble Previous' })

-- Test
key.set('n', '<leader>tn', ':TestNearest<CR>', { desc = '[T]est [N]earest' })
key.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[T]est [F]ile' })



