require("lazy").setup({
    {
        'williamboman/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
        config = function()
            require("plugin_config.mason")
        end,
    },

    -- Basics
    'equalsraf/neovim-gui-shim',

    -- Tree view
    {
        'nvim-tree/nvim-tree.lua',
        cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFocus', 'NvimTreeFindFile' },
        config = function()
            require("plugin_config.nvimtree")
        end,
    },

    -- Mini files
    {
        'echasnovski/mini.files',
        version = '*',
        keys = { '-' },
        config = function()
            require("plugin_config.mini-files")
        end,
    },

    -- Comments
    'tpope/vim-commentary',
    'tpope/vim-surround',

    -- Open SCAD
    "sirtaj/vim-openscad",

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim'
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

    -- Theme
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require("plugin_config.colorscheme")
        end,
    },
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

    -- Coding
    --'folke/trouble.nvim',
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
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
            -- Automatic LSP install & dap install
            'williamboman/mason-lspconfig.nvim',
            --'jay-babu/mason-nvim-dap.nvim',

            -- LSP status info on bottom right
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Nvim dev/lua stuff
            'folke/neodev.nvim',

            'hrsh7th/cmp-nvim-lsp',

            -- LSP completion icons
            'onsails/lspkind.nvim'
        },
        config = function()
            require("plugin_config.lsp")
        end,
    },

    -- DAP
    -- {
    --     "rcarriga/nvim-dap-ui",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         "nvim-neotest/nvim-nio"
    --     }
    -- },
    -- 'theHamsta/nvim-dap-virtual-text',
    -- 'mfussenegger/nvim-dap',

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
            -- Snippet engine and nvim-cmp source
            { 'L3MON4D3/LuaSnip', version = 'v2.4.1' }, -- v2.4.2+ has circular dep bug with nvim 0.11
            'saadparwaiz1/cmp_luasnip',

            -- LSP completion
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            -- User friendly snippets
            'rafamadriz/friendly-snippets',
            'zbirenbaum/copilot-cmp'
        },
        config = function()
            require("plugin_config.completions")
        end,
    },

    -- CoPilot
    -- "zbirenbaum/copilot.lua",

    -- Rust
    { 'simrat39/rust-tools.nvim', ft = 'rust' },

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
        'vim-test/vim-test',
        cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
        config = function()
            require("plugin_config.vim-test")
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
