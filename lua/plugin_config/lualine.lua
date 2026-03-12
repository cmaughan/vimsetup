require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'carbonfox',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      { 'filename', path = 1 },
      -- Show macro recording indicator
      {
        function()
          local reg = vim.fn.reg_recording()
          return reg ~= '' and '⏺ @' .. reg or ''
        end,
        color = { fg = '#ff9e64', gui = 'bold' },
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
