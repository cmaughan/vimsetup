require("lazy").setup({
    -- Basics
    'equalsraf/neovim-gui-shim',

    -- Tree view
    'nvim-tree/nvim-tree.lua',

    -- Essential edit file system like a tree
    'stevearc/oil.nvim',

    -- Comments
    'tpope/vim-commentary',
    'tpope/vim-surround',

    -- Leap
    'ggandor/leap.nvim',

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
    },

    -- Harpoon
    {
        'ThePrimeagen/harpoon',
        branch = 'master',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = {
            menu = {
                width = 120
            }
        }
    },

    -- Theme
    'navarasu/onedark.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'hiphish/rainbow-delimiters.nvim',
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}, commit = "29be0919b91fb59eca9e90690d76014233392bef" },

    -- Sharing
    'kristijanhusak/vim-carbon-now-sh',

    -- Window management
    'folke/zen-mode.nvim',
    'wesQ3/vim-windowswap',
    'mtth/scratch.vim',
    'folke/twilight.nvim',

    -- Git
    'tpope/vim-fugitive',

    -- 'NeogitOrg/neogit',
    'sindrets/diffview.nvim',
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to next hunk' })

                map({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to previous hunk' })

                -- Actions
                -- visual mode
                map('v', '<leader>gs', function()
                    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'stage git hunk' })
                map('v', '<leader>gr', function()
                    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'reset git hunk' })
                -- normal mode
                map('n', '<leader>gs', gs.stage_hunk, { desc = '[G]it [s]tage hunk' })
                map('n', '<leader>gr', gs.reset_hunk, { desc = '[G]it [R]eset hunk' })
                map('n', '<leader>gS', gs.stage_buffer, { desc = '[G]it [S]tage buffer' })
                map('n', '<leader>gu', gs.undo_stage_hunk, { desc = '[G]it [U]ndo stage' })
                --map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
                map('n', '<leader>gp', gs.preview_hunk, { desc = '[G]it [P]review hunk' })
                map('n', '<leader>gb', function()
                    gs.blame_line { full = false }
                end, { desc = '[G]it [B]lame line' })
                map('n', '<leader>gd', gs.diffthis, { desc = '[G]it diff - index' })
                map('n', '<leader>gD', function()
                    gs.diffthis '~'
                end, { desc = '[G]it diff - commit' })

                -- Toggles
                map('n', '<leader>ob', gs.toggle_current_line_blame, { desc = 'T[O]ggle git [B]lame line' })
                map('n', '<leader>od', gs.toggle_deleted, { desc = 'T[O]ggle git [D]eleted' })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
            end,
        },
    },

    -- Coding
    --'folke/trouble.nvim',
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatic LSP install & dap install
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'jay-babu/mason-nvim-dap.nvim',

            -- LSP status info on bottom right
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Nvim dev/lua stuff
            'folke/neodev.nvim',

            -- LSP completion icons
            'onsails/lspkind.nvim'
        },
    },

    -- DAP
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },
    'theHamsta/nvim-dap-virtual-text',
    'mfussenegger/nvim-dap',

    -- Pending keybinds
    { 'folke/which-key.nvim',                opts = {} },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim',               opts = {} },

    -- Completions
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet engine and nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- LSP completion
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            -- User friendly snippets
            'rafamadriz/friendly-snippets',
            'zbirenbaum/copilot-cmp'
        },
    },

    -- CoPilot
    "zbirenbaum/copilot.lua",

    -- Rust
    'simrat39/rust-tools.nvim',

    -- Markdown
    { 'iamcco/markdown-preview.nvim', run = "cd app && npm install", },

    -- VimTex
    { 'lervag/vimtex' },

    -- Test
    'vim-test/vim-test',

    -- VimWiki
    'vimwiki/vimwiki',
})
