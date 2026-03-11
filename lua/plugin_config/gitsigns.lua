require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local key = require('util.keymap')
    local function map(mode, l, r, desc)
      key.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation
    map('n', ']h', function()
      if vim.wo.diff then return ']h' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, 'Next [H]unk')
    map('n', '[h', function()
      if vim.wo.diff then return '[h' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, 'Prev [H]unk')

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk,        '[G]it [S]tage hunk')
    map('n', '<leader>gu', gs.undo_stage_hunk,   '[G]it [U]ndo stage hunk')
    map('n', '<leader>gp', gs.preview_hunk,      '[G]it [P]review hunk')
    map('n', '<leader>gd', gs.diffthis,          '[G]it [D]iff this')
    map('n', '<leader>gb', gs.toggle_current_line_blame, '[G]it [B]lame line')
    map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, '[G]it [S]tage hunk')
  end,
}
