-- nvim-iecst: Lazy.nvim installation snippet
--
-- Установка одной командой:
--   curl -fLo ~/.config/nvim/lua/plugins/iecst.lua \
--     https://raw.githubusercontent.com/terlim/IECST_LANG_SUPPORT/main/lazy-snippet.lua
--
-- После установки перезапустите Neovim и откройте .st файл —
-- подсветка заработает автоматически.

return {
  {
    'terlim/IECST_LANG_SUPPORT',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- plugin/iecst.vim регистрирует filetype patterns при старте,
    -- поэтому ft= здесь не нужен — достаточно навесить config на ft
    config = function()
      require('iecst').setup()
    end,
    ft = { 'iecst' },
  },
}
