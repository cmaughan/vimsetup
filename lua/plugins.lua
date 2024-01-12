require("lazy").setup({
    -- Basics
    'equalsraf/neovim-gui-shim',
    'nvim-tree/nvim-tree.lua',
    'stevearc/oil.nvim',
    'smoka7/hop.nvim',
    'tpope/vim-commentary',
    'tpope/vim-surround',

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
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl',  opts = {} },

    -- Window management
    'folke/zen-mode.nvim',
    'wesQ3/vim-windowswap',
    'mtth/scratch.vim',

    'nvim-neorg/neorg',
    { 'vimwiki/vimwiki',                     branch = "dev" },

    -- Git
    'tpope/vim-fugitive',
    'NeogitOrg/neogit',
    'sindrets/diffview.nvim',
    'lewis6991/gitsigns.nvim',

    -- Coding
    'folke/trouble.nvim',
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
            -- Automatic LSP install stdpath
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- LSP status info
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Nvim dev/lua stuff
            'folke/neodev.nvim',
        },
    },
    -- Pending keybinds
    { 'folke/which-key.nvim',  opts = {} },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    'williamboman/mason-lspconfig.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'vim-test/vim-test',

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
        },
    },
    --"github/copilot.vim",

    -- Rust
    'simrat39/rust-tools.nvim',

    { 'iamcco/markdown-preview.nvim', run = "cd app && npm install", },
})
