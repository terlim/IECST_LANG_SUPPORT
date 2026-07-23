-- nvim-iecst: Lazy.nvim installation snippet
--
-- Установка одной командой:
--   curl -fLo ~/.config/nvim/lua/plugins/iecst.lua \
--     https://raw.githubusercontent.com/terlim/IECST_LANG_SUPPORT/main/lazy-snippet.lua
--
-- После установки перезапустите Neovim — парсер установится автоматически
-- при первом открытии .st файла.

return {
  {
    'terlim/IECST_LANG_SUPPORT',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'iecst', 'st' },
    config = function()
      -- 1. Зарегистрировать парсер в nvim-treesitter
      local config = require('iecst.config').defaults
      require('iecst.treesitter').setup(config)
      -- 2. Установить парсер (скомпилировать .so)
      require('iecst.treesitter').install()
      -- 3. Загрузить подсветку, фолдинг, отступы
      require('iecst').setup()
    end,
  },
}
