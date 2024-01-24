local key = vim.keymap

-- Esc --
key.set('i', 'jk', '<ESC>', { desc = '[j][k] Escape' })
key.set('t', 'jk', [[<C-\><C-n>]], { desc = '[j][k] Escape' })

-- Tree
key.set('n', '<c-t>', ':NvimTreeToggle<CR>', { desc = "Tree Toggle" })

-- Oil
key.set('n', '-', require("oil").open, { desc = "Open parent directory" })

-- Telescope
local telescope = require('telescope.builtin')
key.set('n', '<c-p>', telescope.find_files, { desc = 'Telescope Find Files' })
key.set('n', '<c-,>', telescope.find_files, { desc = 'Telescope Find Files' })
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
key.set('n', '<leader>fh', telescope.help_tags, { desc = '[F]ind [h]elp' })
key.set('n', '<leader>fi', telescope.git_files, { desc = '[F]ind files in G[i]t' })
key.set('n', '<leader>fw', telescope.grep_string, { desc = '[F]ind current [W]ord' })
key.set('n', '<leader>fd', telescope.diagnostics, { desc = '[F]ind [D]iagnostics' })
key.set('n', '<leader>fa', telescope.resume, { desc = '[F]ind [A]again' })
key.set('n', '<leader>fs', telescope.builtin, { desc = '[F]ind [S]elect Telescope Type' })

-- Hopword Jump
key.set('n', '<leader>fj', ':HopWord<CR>', { desc = '[F]ind [J]ump' })

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
key.set('n', '<C-\\>', ':split term://pwsh<CR>', { noremap = true, desc = '[C-\\] Terminal' }) -- open
key.set('t', '<Esc>', '<C-\\><C-n>', {desc = '[E]scape Terminal' })                           -- exit
key.set('t', '<C-o>', '<C-\\><C-n><C-o>', { desc = '[E]scape Terminal' })                           -- exit

-- Navigate vim p:anes better
key.set('n', '<c-h>', ':wincmd h<CR>', { desc = '[<c-h>] Left Pane' })
key.set('n', '<c-l>', ':wincmd l<CR>', { desc = '[<c-l>] Right Pane' })

key.set('n', '<c-s-H>', 'gT', { desc = '[c-H] Left Tab' })
key.set('n', '<c-s-L>', 'gt', { desc = '[c-L] Right Tab' })

-- Move around splits using Ctrl + {h,j,k,l}
key.set('', '<C-h>', '<C-w>h', { desc = '[C-h] Left Pane' })
key.set('', '<C-j>', '<C-w>j', { desc = '[C-l] Left Pane' })
key.set('', '<C-k>', '<C-w>k', { desc = '[C-k] Down Pane' })
key.set('', '<C-l>', '<C-w>l', { desc = '[C-k] Up Pane' })
key.set('t', '<c-k>', '<C-\\><C-n> :wincmd k<CR>', { desc = '[<c-k>] Up Pane' })
key.set('t', '<c-j>', '<C-\\><C-n> :wincmd j<CR>', { desc = '[<c-j>] Down Pane' })
key.set('t', '<c-h>', '<C-\\><C-n> :wincmd h<CR>', { desc = '[<c-h>] Left Pane' })
key.set('t', '<c-l>', '<C-\\><C-n> :wincmd l<CR>', { desc = '[<c-l>] Up Pane' })


key.set('n', 'j', 'gj', { desc = '[<J>] down' })
key.set('n', 'k', 'gk', { desc = '[<K>] up' })
key.set('n', 'gj', 'j', { desc = '[<gj>] <j>' })
key.set('n', 'gk', 'k', { desc = '[<gk>] <k>' })
-- Some kind of special pane move? key.set('n', '<c-l>', ':wincmd l<CR>', { desc = '[c-l] ' })

-- Move visual selection up and down
key.set('v', 'K', ':m \'<-2<CR>gv=gv', { desc = '[<K>] Visual up' })
key.set('v', 'J', ':m \'>+1<CR>gv=gv', { desc = '[<J>] Visual down' })

-- Append to line, keep cursor at beginning
key.set('n', 'J', 'mzJ`z', { desc = '[<J>] Append to line' })

-- Keep cursor in middle while going up/down
key.set('n', '<c-d>', "<c-d>zz", { desc = '[c-d] Down, Center Cur' })
key.set('n', '<c-u>', "<c-u>zz", { desc = '[c-u] Up, Center Cur' })
key.set('n', '<c-f>', "<c-f>zz", { desc = '[c-f] Forward, Center Cur' })
key.set('n', '<c-b>', "<c-b>zz", { desc = '[c-b] Back, Center Cur' })

key.set('n', 'n', 'nzzzv', { desc = '[n] Forward search center' })
key.set('n', 'N', 'Nzzzv', { desc = '[N] Backward search center' })

-- Ignore this
key.set('n', 'Q', "<nop>", { desc = '[Q] Ignored' })

-- Ignore arrows
key.set('', '<up>', '<nop>', { desc = '[<up>] Ignored' })
key.set('', '<down>', '<nop>', { desc = '[<down>] Ignored' })
key.set('', '<left>', '<nop>', { desc = '[<left>] Ignored' })
key.set('', '<right>', '<nop>', { desc = '[<right>] Ignored' })

-- Paste over and keep selection
key.set('x', '<leader>p', '\"_dP', { desc = '[P]aste over keep' })

-- Clear search highlighting with <leader> and c
key.set('n', '<leader>cs', ':nohl<CR>', { desc = '[C]lear [S]earch' })

-- Toggle auto-indenting for code paste
-- key.set('n', '<F2>', ':set invpaste paste?<CR>', { desc = '' })

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

key.set('n', '<leader>oc', ':nohlsearch<CR>', { desc = 'T[O]ggle search [C]lear' })
key.set('n', '<leader>ko', ':ClangdSwitchSourceHeader<CR>', { desc = '[K] Go [O]ther' })
key.set('n', 'go', ':ClangdSwitchSourceHeader<CR>', { desc = '[G]o [O]ther' })

-- Edit VimRC
local vimrc_path = vim.fn.expand("$MYVIMRC")
local parent_path = vim.fn.fnamemodify(vimrc_path, ":h")
key.set('n', '<leader>ev', ':e $MYVIMRC<CR>', { desc = '[E]dit V[imrc' })
key.set('n', '<leader>ek', ':e ' .. parent_path .. '/lua/keymaps.lua<CR>', { desc = '[E]dit [K]eymaps' })
key.set('n', '<leader>eo', ':e ' .. parent_path .. '/lua/options.lua<CR>', { desc = '[E]dit [O]ptions' })
key.set('n', '<leader>ep', ':e ' .. parent_path .. '/lua/plugins.lua<CR>', { desc = '[E]dit [P]lugins' })
key.set('n', '<leader>ec', ':e ' .. parent_path .. '/lua/plugin_config<CR>', { desc = '[E]edit [C]onfig folder' })

-- Dap
key.set("n", "<Leader>dx", ':DapTerminate<CR>', { desc = 'DAP: [D]ebug E[x]it' })
key.set("n", "<Leader>db", ':DapToggleBreakpoint<CR>', { desc = 'DAP: [D]ebug [B]readkpoint' })
key.set('n', '<F5>', ':DapContinue<CR>', { desc = 'DAP: [<F5>] Continue' })
key.set("n", "<F10>", ':DapStepOver<CR>', { desc = 'DAP: [<F10>] Step Over' })
key.set("n", "<F11>", ':DapStepInto<CR>', { desc = 'DAP: [<F11>] Step Into' })

-- Quick list
key.set('n', '<leader>ld', vim.diagnostic.setqflist, { silent = true, buffer = true, desc = 'Quick [L]ist Ad[D]' })

-- Test
key.set('n', '<leader>tn', ':TestNearest<CR>', { desc = '[T]est [N]earest' })
key.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[T]est [F]ile' })

key.set('n', '<leader>os', ':Scratch<CR>', { desc = 'T[o]ggle [S]cratch' })

key.set('n', ']q', ':cn<CR>', { desc = 'Next [Q]uickfix' })
key.set('n', '[q', ':cp<CR>', { desc = 'Previous [Q]uickfix' })


function _G.next_quickfix_wrap()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
        print("Quickfix list is empty.")
        return
    end

    local status, _ = pcall(function() vim.cmd('cnext') end)
    if not status then
        print("Reached the end of the quickfix list. Wrapping to the first entry.")
        vim.cmd('cfirst')
    end
end

function _G.prev_quickfix_wrap()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
        print("Quickfix list is empty.")
        return
    end

    local status, _ = pcall(function() vim.cmd('cprev') end)
    if not status then
        print("Reached the start of the quickfix list. Wrapping to the first entry.")
        vim.cmd('clast')
    end
end

key.set('n', '<F8>', function()
    vim.api.nvim_command('copen')
    next_quickfix_wrap()
end, { desc = '[<F8>]QuickFix Next' })

key.set('n', '<S-F8>', function()
    prev_quickfix_wrap()
end, { desc = '[<S-F8>]QuickFix Previous' })


