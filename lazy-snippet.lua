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
    -- Загружаем при старте, чтобы :TSInstall iecst сразу видел парсер
    event = 'VeryLazy',
    -- Регистрируем парсер в nvim-treesitter немедленно (до config)
    init = function()
      -- Сообщаем nvim-treesitter о парсере, чтобы :TSInstall знал откуда ставить
      local config = require('iecst.config').defaults
      pcall(function()
        local parsers = require('nvim-treesitter.parsers')
        parsers.iecst = {
          install_info = {
            url      = config.parser.url,
            branch   = config.parser.branch,
            files    = { 'src/parser.c', 'src/scanner.c' },
            generate = config.parser.generate,
          },
          filetype = config.parser.filetype,
        }
        -- Совместимость со старыми версиями nvim-treesitter
        pcall(function()
          parsers.get_parser_configs().iecst = parsers.iecst
        end)
      end)
      -- Назначаем filetype сразу
      require('iecst.filetype').setup()
    end,
    ft = { 'iecst', 'st' },
    config = function()
      require('iecst').setup()
    end,
  },
}
