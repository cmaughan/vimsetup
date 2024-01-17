-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ebug', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]plits', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]rouble', _ = 'which_key_ignore' },
  ['<leader>o'] = { name = 'T[O]ggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]iki', _ = 'which_key_ignore' },
  ['<leader>k'] = { name = '[K]swap other', _ = 'which_key_ignore' },
  ['<leader>v'] = { name = '[V]v/h swap', _ = 'which_key_ignore' },
  ['<leader>l'] = { name = '[L]SP', _ = 'which_key_ignore' },
  ['<leader>e'] = { name = '[E]dit', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })


