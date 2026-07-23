-- nvim-iecst/lua/iecst/config.lua
-- Default configuration for the IECST plugin.

local M = {}

M.defaults = {
  -- Filetypes that activate IECST treesitter
  filetypes = { 'iecst', 'st' },

  -- File extensions to auto-detect as IECST
  extensions = { 'st', 'ST', 'iecst', 'IECST' },

  -- Parser configuration for nvim-treesitter
  parser = {
    -- Source repository (should be published to npm / github)
    url = 'https://github.com/HeytalePazguato/tree-sitter-iec61131-3-st.git',
    -- Use the CODESYS dialect grammar (tree-sitter-iecst)
    -- When published, replace url with your fork.
    --
    -- For now we reference the base grammar and layer our dialect
    -- queries on top.  The actual dialect grammar lives in
    -- ../tree-sitter-iecst/.
    branch = 'main',
    generate = true,
    filetype = 'iecst',
  },

  -- Highlight groups enabled by default
  highlight = {
    enable = true,
  },

  -- Indentation enabled by default
  indent = {
    enable = true,
  },

  -- Folding enabled by default
  fold = {
    enable = true,
  },
}

--- Merge user config with defaults.
---@param user table|nil
---@return table
function M.setup(user)
  return vim.tbl_deep_extend('force', vim.deepcopy(M.defaults), user or {})
end

return M
