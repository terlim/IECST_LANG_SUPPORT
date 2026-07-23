-- nvim-iecst/lua/iecst/treesitter.lua

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    once = true,
    callback = function()
      local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
      if not ok then return end

      parsers.iecst = {
        install_info = {
          url      = 'https://github.com/HeytalePazguato/tree-sitter-iec61131-3-st.git',
          branch   = 'main',
          files    = { 'src/parser.c', 'src/scanner.c' },
          generate = true,
        },
        filetype = 'iecst',
      }
      vim.treesitter.language.register('iecst', { 'iecst' })
      vim.notify('[nvim-iecst] Parser registered. Run :TSInstall iecst to install.', vim.log.levels.INFO)
    end,
  })
end

return M
