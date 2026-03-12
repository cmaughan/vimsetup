local key = require("util.keymap")

-- Esc --
key.set('i', 'jk', '<ESC>', { desc = '[j][k] Escape' })
key.set('t', 'jk', [[<C-\><C-n>]], { desc = '[j][k] Escape' })

-- Telescope
key.set('n', '<c-p>', function() require('telescope.builtin').find_files() end, { desc = 'Telescope Find Files' })
key.set('n', '<c-,>', function() require('telescope.builtin').find_files() end, { desc = 'Telescope Find Files' })
key.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end, { desc = '[?] Find recently opened files' })
key.set('n', '<leader><space>', function() require('telescope.builtin').buffers() end, { desc = '[ ] Find existing buffers' })
key.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' }
)
key.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = '[F]ind [G]rep' })
key.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = '[F]ind [B]uffers' })
key.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = '[F]ind [h]elp' })
key.set('n', '<leader>fi', function() require('telescope.builtin').git_files() end, { desc = '[F]ind files in G[i]t' })
key.set('n', '<leader>fw', function() require('telescope.builtin').grep_string() end, { desc = '[F]ind current [W]ord' })
key.set('n', '<leader>fd', function() require('telescope.builtin').diagnostics() end, { desc = '[F]ind [D]iagnostics' })
key.set('n', '<leader>fa', function() require('telescope.builtin').resume() end, { desc = '[F]ind [A]again' })
key.set('n', '<leader>fs', function() require('telescope.builtin').builtin() end, { desc = '[F]ind [S]elect Telescope Type' })

-- Wiki
--key.set('n', '<leader>ww', ':Neorg index<CR>', { desc = '[W]iki [W]iki' })

-- Harpoon (v2)
key.set("n", "<leader>ha", function() require("harpoon"):list():add() end, { desc = '[H]arpoon [A]dd' })
key.set("n", "<leader>hh", function()
    local h = require("harpoon")
    h.ui:toggle_quick_menu(h:list())
end, { desc = '[H]arpoon [H]arpoon' })
key.set("n", "<leader>h1", function() require("harpoon"):list():select(1) end, { desc = '[H]arpoon [1]' })
key.set("n", "<leader>h2", function() require("harpoon"):list():select(2) end, { desc = '[H]arpoon [2]' })
key.set("n", "<leader>h3", function() require("harpoon"):list():select(3) end, { desc = '[H]arpoon [3]' })
key.set("n", "<leader>h4", function() require("harpoon"):list():select(4) end, { desc = '[H]arpoon [4]' })
key.set("n", "<leader>h5", function() require("harpoon"):list():select(5) end, { desc = '[H]arpoon [5]' })
key.set("n", "<leader>h6", function() require("harpoon"):list():select(6) end, { desc = '[H]arpoon [6]' })
key.set("n", "<leader>h7", function() require("harpoon"):list():select(7) end, { desc = '[H]arpoon [7]' })
key.set("n", "<leader>h8", function() require("harpoon"):list():select(8) end, { desc = '[H]arpoon [8]' })
key.set("n", "<leader>h9", function() require("harpoon"):list():select(9) end, { desc = '[H]arpoon [9]' })

-- Zen mode
key.set('n', '<leader>z', ':ZenMode<CR>', { desc = '[Z]en mode' })

-- Window swap (directional, via smart-splits)
key.set('n', '<leader>wh', function() require('smart-splits').swap_buf_left() end,  { desc = '[W]indow swap left' })
key.set('n', '<leader>wj', function() require('smart-splits').swap_buf_down() end,  { desc = '[W]indow swap down' })
key.set('n', '<leader>wk', function() require('smart-splits').swap_buf_up() end,    { desc = '[W]indow swap up' })
key.set('n', '<leader>wl', function() require('smart-splits').swap_buf_right() end, { desc = '[W]indow swap right' })

-- Terminal mappings (toggleterm handles <C-\> open/close)
key.set('t', '<Esc>', '<C-\\><C-n>', { desc = '[E]scape Terminal' })
key.set('t', '<C-o>', '<C-\\><C-n><C-o>', { desc = '[E]scape Terminal to normal' })

-- Move around splits using Ctrl + {h,j,k,l} (smart-splits: tmux-aware)
key.set('n', '<C-h>', function() require('smart-splits').move_cursor_left() end,  { desc = '[C-h] Left Pane' })
key.set('n', '<C-j>', function() require('smart-splits').move_cursor_down() end,  { desc = '[C-j] Down Pane' })
key.set('n', '<C-k>', function() require('smart-splits').move_cursor_up() end,    { desc = '[C-k] Up Pane' })
key.set('n', '<C-l>', function() require('smart-splits').move_cursor_right() end, { desc = '[C-l] Right Pane' })
key.set('t', '<C-h>', function() require('smart-splits').move_cursor_left() end,  { desc = '[C-h] Left Pane' })
key.set('t', '<C-j>', function() require('smart-splits').move_cursor_down() end,  { desc = '[C-j] Down Pane' })
key.set('t', '<C-k>', function() require('smart-splits').move_cursor_up() end,    { desc = '[C-k] Up Pane' })
key.set('t', '<C-l>', function() require('smart-splits').move_cursor_right() end, { desc = '[C-l] Right Pane' })

key.set('n', '<c-s-H>', 'gT', { desc = '[C-S-H] Left Tab' })
key.set('n', '<c-s-L>', 'gt', { desc = '[C-S-L] Right Tab' })


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
key.set('n', 'n', 'nzzzv', { desc = '[n] Forward search center' })
key.set('n', 'N', 'Nzzzv', { desc = '[N] Backward search center' })

-- Ignore this
key.set('n', 'Q', "<nop>", { desc = '[Q] Ignored' })

-- Ignore arrows
key.set({ 'n', 'v', 'o' }, '<up>', '<nop>', { desc = '[<up>] Ignored' })
key.set({ 'n', 'v', 'o' }, '<down>', '<nop>', { desc = '[<down>] Ignored' })
key.set({ 'n', 'v', 'o' }, '<left>', '<nop>', { desc = '[<left>] Ignored' })
key.set({ 'n', 'v', 'o' }, '<right>', '<nop>', { desc = '[<right>] Ignored' })

-- Paste over and keep selection
key.set('x', '<leader>p', '\"_dP', { desc = '[P]aste over keep' })

-- Clear search highlighting with <leader> and c
key.set('n', '<leader>cs', ':nohl<CR>', { desc = '[C]lear [S]earch' })

-- Grug-far: search & replace on visual selection
key.set('v', '<leader>sr', function()
    require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
end, { desc = '[S]earch [R]eplace selection (grug-far)' })

-- Replace word under cursor across file
key.set('n', '<leader>rw', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = '[R]eplace [W]ord under cursor' })

-- Toggle auto-indenting for code paste
-- key.set('n', '<F2>', ':set invpaste paste?<CR>', { desc = '' })

-- Split window management
key.set('n', '<leader>sv', '<C-w>v', { desc = '[S]plit [V]ertical' })
key.set('n', '<leader>sh', '<C-w>s', { desc = '[S]plit [H]orizontal' })
key.set('n', '<leader>se', '<C-w>=', { desc = '[S]plit [E]qual' })
key.set('n', '<leader>sx', ':close<CR>', { desc = '[S]plit E[X]it' })
key.set('n', '<leader>sJ', function() require('smart-splits').resize_down(5) end,  { desc = '[S]plit shrink [J]height' })
key.set('n', '<leader>sK', function() require('smart-splits').resize_up(5) end,    { desc = '[S]plit grow [K]height' })
key.set('n', '<leader>sL', function() require('smart-splits').resize_right(5) end, { desc = '[S]plit grow [L]width' })
key.set('n', '<leader>sH', function() require('smart-splits').resize_left(5) end,  { desc = '[S]plit shrink [H]width' })
key.set('n', '<leader>vh', '<C-w>t<C-w>K', { desc = '[V]ertical to [H]orizontal' })
key.set('n', '<leader>hv', '<C-w>t<C-w>H', { desc = '[H]orizontal to [V]ertical' })

-- Edit VimRC
local vimrc_path = vim.fn.expand("$MYVIMRC")
local parent_path = vim.fn.fnamemodify(vimrc_path, ":h")
key.set('n', '<leader>ev', ':e $MYVIMRC<CR>', { desc = '[E]dit [V]imrc' })
key.set('n', '<leader>ek', ':e ' .. parent_path .. '/lua/keymaps.lua<CR>', { desc = '[E]dit [K]eymaps' })
key.set('n', '<leader>eo', ':e ' .. parent_path .. '/lua/options.lua<CR>', { desc = '[E]dit [O]ptions' })
key.set('n', '<leader>ep', ':e ' .. parent_path .. '/lua/plugins.lua<CR>', { desc = '[E]dit [P]lugins' })
key.set('n', '<leader>ec', ':e ' .. parent_path .. '/lua/plugin_config<CR>', { desc = '[E]dit [C]onfig folder' })

-- Quick list
key.set('n', '<leader>ld', vim.diagnostic.setqflist, { silent = true, buffer = true, desc = 'Quick [L]ist Ad[D]' })
key.set('n', '<leader>lf', '<cmd>Format<CR>', { desc = '[L]anguage [F]ormat buffer' })
key.set('n', '<leader>ll', '<cmd>Lint<CR>', { desc = '[L]int current buffer' })
key.set('n', '<leader>ps', '<cmd>SessionSave<CR>', { desc = '[P]roject [S]ession save' })
key.set('n', '<leader>pr', '<cmd>SessionRestore<CR>', { desc = '[P]roject session [R]estore' })
key.set('n', '<leader>px', '<cmd>SessionDelete<CR>', { desc = '[P]roject session delete' })

-- Test
key.set('n', '<leader>tn', function() require("neotest").run.run() end, { desc = '[T]est [N]earest' })
key.set('n', '<leader>tf', function() require("neotest").run.run(vim.fn.expand('%')) end, { desc = '[T]est [F]ile' })

key.set('n', '<leader>os', ':Scratch<CR>', { desc = 'T[o]ggle [S]cratch' })

-- key.set('n', '-', ':VimwikiGoBackLink<CR>', { desc = '[B]ack to previous' })

key.set('n', ']q', ':cn<CR>', { desc = 'Next [Q]uickfix' })
key.set('n', '[q', ':cp<CR>', { desc = 'Previous [Q]uickfix' })

key.set('n', '<leader>m', ':let @*=trim(execute(\'messages\')) | echo \'copied\' <cr>', { desc = 'Copy [M]essages' })

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
