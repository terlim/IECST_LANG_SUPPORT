-- nvim-iecst/lua/iecst/treesitter.lua
-- Register the IECST parser with nvim-treesitter and load queries.

local M = {}

local has_parsers_module = pcall(require, 'nvim-treesitter.parsers')
local has_configs_module = pcall(require, 'nvim-treesitter.configs')

--- Ensure nvim-treesitter knows about our parser so :TSInstall iecst
--- works. This must be called unconditionally during setup(), even
--- when the parser .so is not yet installed.
---
---@param config table  Merged plugin configuration.
function M.setup(config)
  local parser_url = config.parser.url
  local branch     = config.parser.branch
  local generate   = config.parser.generate
  local filetype   = config.parser.filetype

  local parser_def = {
    install_info = {
      url      = parser_url,
      branch   = branch,
      files    = { 'src/parser.c', 'src/scanner.c' },
      generate = generate,
    },
    filetype = filetype,
  }

  -- Register directly in parsers table (works in latest nvim-treesitter)
  if has_parsers_module then
    pcall(function()
      require('nvim-treesitter.parsers').iecst = parser_def
      -- Also register via get_parser_configs() for older nvim-treesitter releases
      pcall(function()
        require('nvim-treesitter.parsers').get_parser_configs().iecst = parser_def
      end)
    end)
  end

  -- Map the parser name to our filetype
  pcall(vim.treesitter.language.register, 'iecst', { 'iecst' })
end

return M
