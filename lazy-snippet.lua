-- nvim-iecst: Lazy.nvim installation snippet
--
-- Скопируй этот блок в твой lazy.nvim конфиг.
-- Обычно это: ~/.config/nvim/lua/plugins/ или init.lua
--
-- ИЛИ установи одной командой:
--   curl -fLo ~/.config/nvim/lua/plugins/iecst.lua \
--     https://raw.githubusercontent.com/terlim/IECST_LANG_SUPPORT/main/lazy-snippet.lua
--
-- После установки открой .st файл — подсветка заработает автоматически.

return {
  -- Парсер + подсветка синтаксиса (lazy.nvim сам клонирует репозиторий)
  {
    'terlim/IECST_LANG_SUPPORT',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'iecst', 'st' },
    config = function()
      require('iecst').setup()
    end,
  },

  -- С автоустановкой парсера + предсборкой .so (рекомендуется)
  -- Раскомментируй этот блок если использовал install.sh
  -- {
  --   'terlim/IECST_LANG_SUPPORT',
  --   dir = vim.fn.expand('~/.local/share/nvim-iecst'),
  --   dependencies = {
  --     {
  --       'nvim-treesitter/nvim-treesitter',
  --       opts = {
  --         ensure_installed = { 'iecst' },
  --         highlight = { enable = true },
  --         indent    = { enable = true },
  --         fold      = { enable = true },
  --       },
  --     },
  --   },
  --   ft = { 'iecst', 'st' },
  --   config = function()
  --     -- Копирует предсобранный parser.so (install.sh уже собрал)
  --     local src = vim.fn.expand('~/.local/share/nvim-iecst/tree-sitter-iecst/iecst.so')
  --     local dst = vim.fn.expand('~/.local/share/nvim/tree-sitter/iecst.so')
  --     if vim.fn.filereadable(src) == 1 and vim.fn.filereadable(dst) ~= 1 then
  --       vim.fn.mkdir(vim.fn.fnamemodify(dst, ':h'), 'p')
  --       vim.loop.fs_copyfile(src, dst)
  --     end
  --     require('iecst').setup()
  --   end,
  -- },
}
