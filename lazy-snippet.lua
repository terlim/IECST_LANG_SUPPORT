-- nvim-iecst: Lazy.nvim installation snippet
--
-- Установка одной командой:
--   curl -fLo ~/.config/nvim/lua/plugins/iecst.lua \
--     https://raw.githubusercontent.com/terlim/IECST_LANG_SUPPORT/main/lazy-snippet.lua
--
-- После установки:
--   1. Перезапусти Neovim
--   2. Выполни :TSInstall iecst
--   3. Открой .st файл — подсветка заработает автоматически.

return {
  {
    'terlim/IECST_LANG_SUPPORT',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- Без ft= — plugin/iecst.vim должен загрузиться до :TSInstall
    ft = { 'iecst', 'st' },
    config = function()
      require('iecst').setup()
    end,
  },
}
