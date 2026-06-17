require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<C-o>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-CR>'] = { 'select_and_accept', 'fallback' },
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        ['<C-j>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    },

    appearance = {
        nerd_font_variant = 'mono',
    },

    completion = {
        documentation = { auto_show = false },
        ghost_text = { enabled = true },
        menu = {
            draw = {
                columns = {
                    { 'label', 'label_description', gap = 1 },
                    { 'kind_icon', 'kind' },
                },
            },
        },
    },

    snippets = { preset = 'default' },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
            copilot = {
                name = 'copilot',
                module = 'blink-cmp-copilot',
                async = true,
                score_offset = 100,
            },
        },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
})
