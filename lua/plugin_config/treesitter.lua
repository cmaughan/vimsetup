-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  local ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not ok then return end
  configs.setup {
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'html', 'css', 'yaml', 'markdown', 'markdown_inline' },
    auto_install = false,
    sync_install = false,
    ignore_install = {},
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- <C-space> avoids the <C-v> visual block mode conflict
        init_selection    = '<C-space>',
        node_incremental  = '<C-space>',
        node_decremental  = '<bs>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start     = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
        goto_next_end       = { [']M'] = '@function.outer', [']['] = '@class.outer' },
        goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
        goto_previous_end   = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
      },
      swap = {
        enable = true,
        swap_next     = { ['<leader>sn'] = '@parameter.inner' },
        swap_previous = { ['<leader>sp'] = '@parameter.inner' },
      },
    },
  }
end, 0)

local ok, context = pcall(require, 'treesitter-context')
if ok then
  context.setup {
    max_lines = 4,
    multiline_threshold = 1,
  }
end
