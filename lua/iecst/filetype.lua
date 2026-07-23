-- nvim-iecst/lua/iecst/filetype.lua

local M = {}

function M.setup()
  pcall(vim.filetype.add, {
    extension = {
      st    = 'iecst',
      ST    = 'iecst',
      iecst = 'iecst',
      IECST = 'iecst',
    },
  })
end

return M
