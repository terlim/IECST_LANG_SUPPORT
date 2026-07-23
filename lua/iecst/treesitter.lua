-- nvim-iecst/lua/iecst/treesitter.lua
-- Register the IECST parser with nvim-treesitter and load queries.

local M = {}

--- Ensure nvim-treesitter knows about our parser.
--- Call this inside the `TSUpdate` autocmd so the parser can be installed.
---@param config table  Merged plugin configuration.
function M.setup(config)
  local parser_url = config.parser.url
  local branch     = config.parser.branch
  local generate   = config.parser.generate

  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    once = true,
    callback = function()
      -- Register parser so `:TSInstall iecst` will work.
      require('nvim-treesitter.parsers').iecst = {
        install_info = {
          url      = parser_url,
          branch   = branch,
          files    = { 'src/parser.c', 'src/scanner.c' },
          generate = generate,
        },
      }
      -- Map the parser name to our filetype.
      vim.treesitter.language.register('iecst', { 'iecst' })
    end,
  })

  -- If nvim-treesitter is already loaded, trigger the registration
  -- immediately so queries are picked up from this plugin's runtimepath.
  pcall(function()
    if package.loaded['nvim-treesitter'] then
      vim.cmd('doautocmd User TSUpdate')
    end
  end)
end

return M
