require("lazy").setup({
    -- Basics
    'nvim-tree/nvim-tree.lua',
    'stevearc/oil.nvim',
    'smoka7/hop.nvim',
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'williamboman/mason.nvim',
    { 'nvim-telescope/telescope.nvim',       tag = '0.1.4', dependencies = { 'nvim-lua/plenary.nvim' } },

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

    -- 'equalsraf/neovim-gui-shim',

    { 'vimwiki/vimwiki',              branch = "dev" },

    -- Git
    'tpope/vim-fugitive',
    'NeogitOrg/neogit',
    'sindrets/diffview.nvim',
    'lewis6991/gitsigns.nvim',

    -- Coding
    'folke/trouble.nvim',
    'nvim-treesitter/nvim-treesitter',
    'neovim/nvim-lspconfig',
    'williamboman/mason-lspconfig.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'vim-test/vim-test',

    -- Completions
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    --"github/copilot.vim",

    -- Rust
    'simrat39/rust-tools.nvim',

    { 'iamcco/markdown-preview.nvim', run = "cd app && npm install", },
})
