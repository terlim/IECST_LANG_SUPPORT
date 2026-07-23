-- nvim-iecst/lua/iecst/filetype.lua
-- Auto-detection: associate file extensions with the 'iecst' filetype.

local M = {}

--- Register filetype detection patterns.
function M.setup()
  vim.filetype.add({
    extension = {
      st    = 'iecst',
      ST    = 'iecst',
      iecst = 'iecst',
      IECST = 'iecst',
    },
    -- Also detect by filename pattern (case-insensitive on case-insensitive fs).
    pattern = {
      ['.*%.ST$']   = 'iecst',
      ['.*%.IECST$'] = 'iecst',
    },
  })
end

return M
