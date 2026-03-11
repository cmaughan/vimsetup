require("lazy").setup({
    {
        'williamboman/mason.nvim',
        lazy = false,
        cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonToolsInstall', 'MasonToolsInstallSync', 'MasonToolsUpdate', 'MasonToolsUpdateSync', 'MasonToolsClean' },
        dependencies = {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        config = function()
            require("plugin_config.mason")
        end,
    },

    -- Basics
    'equalsraf/neovim-gui-shim',
    'tpope/vim-repeat',

    -- Mini files
    {
        'echasnovski/mini.files',
        version = '*',
        keys = {
            {
                '-',
                function()
                    local MiniFiles = require("mini.files")
                    local buf_name = vim.api.nvim_buf_get_name(0)
                    local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
                    MiniFiles.open(path, false)
                end,
                desc = "Open Mini Files",
            },
            {
                '<C-t>',
                function()
                    local MiniFiles = require("mini.files")
                    local buf_name = vim.api.nvim_buf_get_name(0)
                    local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
                    if not MiniFiles.close() then
                        MiniFiles.open(path, false)
                    end
                end,
                desc = "Files Toggle",
            },
        },
        config = function()
            require("plugin_config.mini-files")
        end,
    },

    -- Comments
    { 'kylechui/nvim-surround', event = 'VeryLazy', opts = {} },

    {
        'stevearc/conform.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        cmd = { 'ConformInfo' },
        config = function()
            require("plugin_config.formatting")
        end,
    },
    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require("plugin_config.linting")
        end,
    },

    -- Open SCAD
    "sirtaj/vim-openscad",

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
        },
        config = function()
            require("plugin_config.telescope")
        end,
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
        },
    },

    -- Theme: Carbonfox via Nightfox is the startup default.
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require("plugin_config.colorscheme")
        end,
    },
    { 'rebelot/kanagawa.nvim', lazy = true },
    { 'ellisonleao/gruvbox.nvim', lazy = true },
    'nvim-tree/nvim-web-devicons',
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        config = function()
            require("plugin_config.lualine")
        end,
    },
    'hiphish/rainbow-delimiters.nvim',
    'lukas-reineke/indent-blankline.nvim',

    -- Sharing
    'kristijanhusak/vim-carbon-now-sh',

    -- Window management
    'wesQ3/vim-windowswap',

    -- Git
    'tpope/vim-fugitive',

    -- 'NeogitOrg/neogit',
    'sindrets/diffview.nvim',

    -- Highlight TODO/FIXME/HACK/NOTE comments
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
        keys = {
            { '<leader>ft', '<cmd>TodoTelescope<cr>', desc = '[F]ind [T]odo comments' },
            { ']t', function() require('todo-comments').jump_next() end, desc = 'Next [T]odo' },
            { '[t', function() require('todo-comments').jump_prev() end, desc = 'Prev [T]odo' },
        },
    },

    -- Better folding with counts
    {
        'kevinhwang91/nvim-ufo',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'kevinhwang91/promise-async' },
        config = function()
            require('plugin_config.ufo')
        end,
    },

    -- CopilotChat
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        cmd = { 'CopilotChat', 'CopilotChatOpen' },
        dependencies = {
            { 'zbirenbaum/copilot.lua' },
            { 'nvim-lua/plenary.nvim' },
        },
        keys = {
            { '<leader>cc', '<cmd>CopilotChatToggle<cr>',  desc = '[C]opilot [C]hat toggle' },
            { '<leader>ce', '<cmd>CopilotChatExplain<cr>', desc = '[C]opilot [E]xplain' },
            { '<leader>cr', '<cmd>CopilotChatReview<cr>',  desc = '[C]opilot [R]eview' },
            { '<leader>cf', '<cmd>CopilotChatFix<cr>',     desc = '[C]opilot [F]ix' },
        },
        opts = {
            window = { layout = 'vertical', width = 0.35 },
        },
    },

    -- Project-wide search & replace
    {
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        keys = {
            { '<leader>sr', '<cmd>GrugFar<cr>',                                                     desc = '[S]earch [R]eplace (grug-far)' },
            { '<leader>sw', function() require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } }) end, desc = '[S]earch [W]ord (grug-far)' },
        },
        opts = { headerMaxWidth = 80 },
    },

    -- Symbol tree (outline)
    {
        'stevearc/aerial.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('plugin_config.aerial')
        end,
    },

    -- Git signs in gutter + hunk actions
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('plugin_config.gitsigns')
        end,
    },

    -- Better diagnostics/quickfix list
    {
        'folke/trouble.nvim',
        cmd = { 'Trouble' },
        keys = {
            { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = '[X]X diagnostics (buffer)' },
            { '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>',              desc = '[X]X diagnostics (workspace)' },
            { '<leader>xq', '<cmd>Trouble qflist toggle<cr>',                   desc = '[X] [Q]uickfix list' },
        },
        opts = {},
    },

    -- Extended text objects (ia/aa, if/af, ic/ac + more)
    {
        'echasnovski/mini.ai',
        version = '*',
        event = 'VeryLazy',
        opts = {},
    },

    -- Coding

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-context',
        },
        build = ':TSUpdate',
        config = function()
            require("plugin_config.treesitter")
        end,
    },

    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- LSP status info on bottom right
            { 'j-hui/fidget.nvim',       opts = {} },

            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            require("plugin_config.lsp")
        end,
    },

    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Pending keybinds
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require("plugin_config.which_key")
        end,
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim',               opts = {} },

    -- Completions
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip', version = 'v2.4.1' },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'onsails/lspkind.nvim',
            'rafamadriz/friendly-snippets',
            'zbirenbaum/copilot-cmp',
        },
        config = function()
            require("plugin_config.completions")
        end,
    },

    -- CoPilot
    -- "zbirenbaum/copilot.lua",

    -- Rust
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        ft = 'rust',
        init = function()
            require("plugin_config.rustaceanvim")
        end,
    },

    -- Markdown
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        build = "cd app && npm install",
        config = function()
            require("plugin_config.markdown_preview")
        end,
    },

    -- VimTex
    { 'lervag/vimtex' },

    -- Test
    {
        'nvim-neotest/neotest',
        cmd = { 'Neotest' },
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-neotest/neotest-vim-test',
            'vim-test/vim-test',
        },
        config = function()
            require("plugin_config.neotest")
        end,
    },

    -- VimWiki
    {
        'vimwiki/vimwiki',
        ft = { 'vimwiki', 'markdown' },
        init = function()
            require("plugin_config.vimwiki")
        end,
    },

    {
        'folke/zen-mode.nvim',
        cmd = 'ZenMode',
        config = function()
            require("plugin_config.zen_mode")
        end,
    },
    {
        'folke/twilight.nvim',
        cmd = 'Twilight',
        config = function()
            require("plugin_config.twilight")
        end,
    },
    {
        'mtth/scratch.vim',
        cmd = 'Scratch',
        config = function()
            require("plugin_config.scratch")
        end,
    },
    {
        url = "https://codeberg.org/andyg/leap.nvim",
        keys = { 's', 'S' },
        config = function()
            require("plugin_config.leap")
        end,
    },
})
