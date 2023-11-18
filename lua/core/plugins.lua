require("lazy").setup({
    'simrat39/rust-tools.nvim',
    'equalsraf/neovim-gui-shim',
    'mtth/scratch.vim',

    -- Debugging
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',

    { 'vimwiki/vimwiki', branch = "dev" },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    'tpope/vim-commentary',
    'mattn/emmet-vim',
    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons',
    'ellisonleao/gruvbox.nvim',
    'dracula/vim',
    'nvim-lualine/lualine.nvim',
    'nvim-treesitter/nvim-treesitter',
    'vim-test/vim-test',
    'lewis6991/gitsigns.nvim',
    'preservim/vimux',
    'christoomey/vim-tmux-navigator',
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    'stevearc/oil.nvim',
    -- completion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    "rafamadriz/friendly-snippets",
    --"github/copilot.vim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    {
        "vinnymeller/swagger-preview.nvim",
        run = "npm install -g swagger-ui-watcher",
    },
    {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
})
