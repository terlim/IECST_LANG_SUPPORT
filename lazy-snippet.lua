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
  -- Плагин IECST
  {
    'terlim/IECST_LANG_SUPPORT',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter',
        -- Регистрируем парсер в nvim-treesitter на этапе конфигурации
        -- (до :TSInstall), чтобы nvim-treesitter знал URL для клонирования.
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'iecst' })
          -- Регистрируем парсер в таблице parsers
          pcall(function()
            require('nvim-treesitter.parsers').iecst = {
              install_info = {
                url = 'https://github.com/HeytalePazguato/tree-sitter-iec61131-3-st.git',
                branch = 'main',
                files = { 'src/parser.c', 'src/scanner.c' },
                generate = true,
              },
              filetype = 'iecst',
            }
            pcall(function()
              require('nvim-treesitter.parsers').get_parser_configs().iecst =
                require('nvim-treesitter.parsers').iecst
            end)
            vim.treesitter.language.register('iecst', { 'iecst' })
          end)
        end,
      },
    },
    config = function()
      require('iecst').setup()
    end,
  },
}
