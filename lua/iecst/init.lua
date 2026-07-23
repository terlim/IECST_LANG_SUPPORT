-- nvim-iecst/lua/iecst/init.lua
-- Entry point.

local M = {}

function M.setup(user_opts)
  -- 1. Проверить наличие nvim-treesitter
  local has_ts = pcall(require, 'nvim-treesitter')
  if not has_ts then
    vim.notify(
      '[nvim-iecst] nvim-treesitter not installed. ' ..
      'Install it first: https://github.com/nvim-treesitter/nvim-treesitter',
      vim.log.levels.ERROR
    )
    return false
  end

  -- 2. Настроить filetype detection
  require('iecst.filetype').setup()

  -- 3. Зарегистрировать парсер в nvim-treesitter
  require('iecst.treesitter').setup()

  -- TODO: следующие шаги — после подтверждения что это работает
  return true
end

return M
