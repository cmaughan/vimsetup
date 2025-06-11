require("lazy").setup({
    -- Basics
    'equalsraf/neovim-gui-shim',

    -- Tree view
    'nvim-tree/nvim-tree.lua',

    -- Mini files
    { 'echasnovski/mini.files', version = '*' },

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
            --'jay-babu/mason-nvim-dap.nvim',

            -- LSP status info on bottom right
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Nvim dev/lua stuff
            'folke/neodev.nvim',

            -- LSP completion icons
            'onsails/lspkind.nvim'
        },
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
