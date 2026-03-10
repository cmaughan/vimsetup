local key = require("util.keymap")

key.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)', { desc = '[S]earch leap forward' })
key.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)', { desc = '[S]earch leap backward' })

-- Exclude whitespace and the middle of alphabetic words from preview:
--   foobar[baaz] = quux
--   ^----^^^--^^-^-^--^
require('leap').opts.preview_filter =
  function (ch0, ch1, ch2)
    return not (
      ch1:match('%s') or
      ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
    )
  end
