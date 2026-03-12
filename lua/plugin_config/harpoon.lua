local key = require("util.keymap")

-- Cycle through harpoon list without opening the menu
key.set("n", "<leader>h[", function() require("harpoon"):list():prev() end, { desc = '[H]arpoon prev' })
key.set("n", "<leader>h]", function() require("harpoon"):list():next() end, { desc = '[H]arpoon next' })
