-- document existing key chains
local wk = require('which-key')

wk.add({
    {'<leader>c',  group = '[C]ode'},
    {'<leader>d',  group = '[D]ebug'},
    {'<leader>g',  group = '[G]it'},
    {'<leader>h',  group = '[H]arpoon'},
    {'<leader>r',  group = '[R]ename'},
    {'<leader>s',  group = '[S]plits'},
    {'<leader>t',  group = '[T]rouble'},
    {'<leader>o',  group = 'T[O]ggle'},
    {'<leader>w',  group = '[W]iki'},
    {'<leader>k',  group = '[K]swap other'},
    {'<leader>v',  group = '[V]v/h swap'},
    {'<leader>l',  group = '[L]SP'},
    {'<leader>e',  group = '[E]dit'},
    {'<leader>f',  group = '[F]ind'},
    {'<leader>',   group = 'VISUAL <leader>' },
    {'<leader>h',  group = 'Git [H]unk' },
})

