local key = require('util.keymap')

require('aerial').setup {
  backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
  layout = {
    max_width = { 40, 0.2 },
    min_width = 25,
    default_direction = 'right',
  },
  show_guides = true,
  attach_mode = 'global',
}

key.set('n', '<leader>a',  '<cmd>AerialToggle<cr>',  { desc = '[A]erial toggle' })
key.set('n', '<leader>fA', '<cmd>Telescope aerial<cr>', { desc = '[F]ind symbol vi[A]erial' })
key.set('n', '{',          '<cmd>AerialPrev<cr>',     { desc = 'Aerial prev symbol' })
key.set('n', '}',          '<cmd>AerialNext<cr>',     { desc = 'Aerial next symbol' })
