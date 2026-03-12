require("lazy").setup({
    {
        'williamboman/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonToolsInstall', 'MasonToolsInstallSync', 'MasonToolsUpdate', 'MasonToolsUpdateSync', 'MasonToolsClean' },
        dependencies = {
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        config = function()
            require("plugin_config.mason")
        end,
    },

    -- Basics
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
        branch = 'harpoon2',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require("harpoon"):setup()
            require("plugin_config.harpoon")
        end,
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
    { 'nyoom-engineering/oxocarbon.nvim', lazy = true },
    'nvim-tree/nvim-web-devicons',
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        config = function()
            require("plugin_config.lualine")
        end,
    },
    'hiphish/rainbow-delimiters.nvim',
    { 'lukas-reineke/indent-blankline.nvim', event = { 'BufReadPost', 'BufNewFile' }, main = 'ibl', opts = {} },

    -- Sharing
    'kristijanhusak/vim-carbon-now-sh',

    -- Window management
    {
        'mrjones2014/smart-splits.nvim',
        lazy = false,
        opts = {},
    },

    -- Git
    'tpope/vim-fugitive',

    { 'sindrets/diffview.nvim', cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' } },

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

    -- Copilot (inline suggestions disabled; used as cmp source)
    {
        'zbirenbaum/copilot.lua',
        event = 'InsertEnter',
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel      = { enabled = false },
            })
            require("plugin_config.copilot")
        end,
    },

    -- CopilotChat
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        cmd = { 'CopilotChat', 'CopilotChatOpen' },
        dependencies = {
            'zbirenbaum/copilot.lua',
            'nvim-lua/plenary.nvim',
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

    -- Extended text objects (ia/aa, if/af, ic/ac + more) with treesitter integration
    {
        'echasnovski/mini.ai',
        version = '*',
        event = 'VeryLazy',
        config = function()
            require('mini.ai').setup({
                n_lines = 500,
                custom_textobjects = {
                    -- Override f to use treesitter function definitions
                    F = require('mini.ai').gen_spec.treesitter({
                        a = '@function.outer',
                        i = '@function.inner',
                    }),
                },
            })
        end,
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

    -- Autopairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup({ check_ts = true })
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },

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
            {
                'zbirenbaum/copilot-cmp',
                config = function()
                    require("copilot_cmp").setup()
                end,
            },
        },
        config = function()
            require("plugin_config.completions")
        end,
    },

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

    -- Obsidian vault navigation
    {
        'epwalsh/obsidian.nvim',
        version = '*',
        ft = 'markdown',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>of', '<cmd>ObsidianQuickSwitch<cr>',  desc = '[O]bsidian [F]ind note' },
            { '<leader>og', '<cmd>ObsidianSearch<cr>',       desc = '[O]bsidian [G]rep' },
            { '<leader>on', '<cmd>ObsidianNew<cr>',          desc = '[O]bsidian [N]ew note' },
            { '<leader>od', '<cmd>ObsidianDailies<cr>',      desc = '[O]bsidian [D]aily notes' },
            { '<leader>ob', '<cmd>ObsidianBacklinks<cr>',    desc = '[O]bsidian [B]acklinks' },
            { '<leader>ot', '<cmd>ObsidianTags<cr>',         desc = '[O]bsidian [T]ags' },
            { '<leader>ol', '<cmd>ObsidianFollowLink<cr>',   desc = '[O]bsidian fo[L]low link' },
        },
        config = function()
            require("plugin_config.obsidian")
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
        'LintaoAmons/scratch.nvim',
        cmd = { 'Scratch', 'ScratchOpen', 'ScratchOpenFtype' },
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

    -- Persistent terminal (replaces the manual split term:// approach)
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        keys = { '<C-\\>' },
        opts = {
            open_mapping    = [[<C-\>]],
            direction       = 'horizontal',
            size            = 15,
            shade_terminals = false,
            persist_mode    = true,
        },
    },

    -- DAP: Debug Adapter Protocol for C / C++ / Rust (codelldb via Mason)
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = { 'nvim-neotest/nvim-nio' },
            },
            { 'theHamsta/nvim-dap-virtual-text', opts = {} },
            {
                'jay-babu/mason-nvim-dap.nvim',
                dependencies = { 'williamboman/mason.nvim' },
                opts = {
                    ensure_installed = { 'codelldb' },
                    -- handlers = {} lets mason-nvim-dap auto-register adapters
                    handlers = {},
                },
            },
        },
        keys = {
            { '<leader>db', function() require('dap').toggle_breakpoint() end,                                    desc = '[D]ebug [B]reakpoint' },
            { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Condition: ')) end,            desc = '[D]ebug [B]reakpoint conditional' },
            { '<leader>dc', function() require('dap').continue() end,                                             desc = '[D]ebug [C]ontinue' },
            { '<leader>di', function() require('dap').step_into() end,                                            desc = '[D]ebug step [I]nto' },
            { '<leader>do', function() require('dap').step_over() end,                                            desc = '[D]ebug step [O]ver' },
            { '<leader>dO', function() require('dap').step_out() end,                                             desc = '[D]ebug step [O]ut' },
            { '<leader>dq', function() require('dap').terminate() end,                                            desc = '[D]ebug [Q]uit' },
            { '<leader>dr', function() require('dap').restart() end,                                              desc = '[D]ebug [R]estart' },
            { '<leader>dl', function() require('dap').run_last() end,                                             desc = '[D]ebug run [L]ast' },
            { '<leader>du', function() require('dapui').toggle() end,                                             desc = '[D]ebug [U]I toggle' },
            { '<leader>de', function() require('dapui').eval() end,                                               desc = '[D]ebug [E]val', mode = { 'n', 'v' } },
            { '<leader>dh', function() require('dap.ui.widgets').hover() end,                                     desc = '[D]ebug [H]over value' },
        },
        config = function()
            require('plugin_config.dap')
        end,
    },
})
