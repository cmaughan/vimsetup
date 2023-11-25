require("lazy").setup({
    'Zeioth/compiler.nvim',
    'neomake/neomake',
    --'folke/trouble.nvim',
    'smoka7/hop.nvim',
    'rmagatti/auto-session',
    'folke/zen-mode.nvim',
    'wesQ3/vim-windowswap',
    'simrat39/rust-tools.nvim',
    'equalsraf/neovim-gui-shim',
    'mtth/scratch.vim',
    'hiphish/rainbow-delimiters.nvim',
    { "lukas-reineke/indent-blankline.nvim", main = 'ibl',  opts = {} },

    -- Debugging
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    { 'vimwiki/vimwiki',                     branch = "dev" },
    --{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    'navarasu/onedark.nvim',
    --{ "olimorris/onedarkpro.nvim", priority = 1000 },
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
    { -- This plugin
        "Zeioth/compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim" },
        opts = {},
    },
    { -- The task runner we use
        "stevearc/overseer.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1
            },
        },
    },
})
