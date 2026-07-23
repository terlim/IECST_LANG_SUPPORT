-- nvim-iecst/lua/iecst/treesitter.lua
-- Register the IECST parser with nvim-treesitter and install it.

local M = {}

--- Register parser info so nvim-treesitter knows where to clone from.
--- Must be called AFTER nvim-treesitter module is loaded (i.e., inside
--- the plugin's config() after the dependency is resolved).
---
---@param config table  Merged plugin configuration.
function M.setup(config)
  local parser_url = config.parser.url
  local branch     = config.parser.branch
  local generate   = config.parser.generate
  local filetype   = config.parser.filetype

  local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ok then
    vim.notify('[nvim-iecst] nvim-treesitter not loaded — cannot register parser', vim.log.levels.WARN)
    return false
  end

  local parser_def = {
    install_info = {
      url      = parser_url,
      branch   = branch,
      files    = { 'src/parser.c', 'src/scanner.c' },
      generate = generate,
    },
    filetype = filetype,
  }

  parsers.iecst = parser_def
  -- Legacy API
  pcall(function()
    parsers.get_parser_configs().iecst = parser_def
  end)
  -- Filetype mapping
  pcall(vim.treesitter.language.register, 'iecst', { 'iecst' })
  return true
end

--- Install the parser .so via nvim-treesitter.
--- Call after M.setup().
function M.install()
  pcall(vim.cmd, 'TSInstallSync iecst')
end

return M
