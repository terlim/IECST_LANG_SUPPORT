-- nvim-iecst/lua/iecst/init.lua
-- Entry point.  Copy to Neovim config or use via lazy.nvim.

local M = {}

-- ── Early parser registration ──────────────────────────────────────
-- Must happen BEFORE nvim-treesitter loads, otherwise the module
-- warns "skipping unsupported language".
-- Only register if the parser .so already exists (nvim-treesitter :TSInstall).
local parser_path = vim.fn.expand('~/.local/share/nvim/tree-sitter/iecst.so')
if vim.fn.filereadable(parser_path) == 1 then
  pcall(vim.treesitter.language.add, 'iecst', { path = parser_path })
  vim.treesitter.language.register('iecst', { 'iecst' })

  -- Pre-register before nvim-treesitter scans ensure_installed
  package.preload['nvim-treesitter.parsers'] = function()
    local parsers = require('nvim-treesitter.parsers')
    parsers.iecst = { install_info = {} }
    return parsers
  end
end
-- ── End early registration ───────────────────────────────────────

local function expand(s)
  return vim.fn.expand(s)
end

function M.setup(user_opts)
  local config = require('iecst.config').setup(user_opts)

  -- 1.  Filetype detection (.st, .ST, .iecst, .IECST)
  require('iecst.filetype').setup()

  -- 2.  Register parser with nvim-treesitter so :TSInstall iecst works
  --     (must happen unconditionally, even before parser .so exists)
  require('iecst.treesitter').setup(config)

  -- 3.  Copy pre-built parser to Neovim's parser directory
  local dest = expand('~/.local/share/nvim/tree-sitter/iecst.so')
  if vim.fn.filereadable(dest) ~= 1 then
    local src = expand('~/.local/share/nvim-iecst/tree-sitter-iecst/iecst.so')
    if vim.fn.filereadable(src) == 1 then
      vim.fn.mkdir(vim.fn.fnamemodify(dest, ':h'), 'p')
      vim.loop.fs_copyfile(src, dest)
    end
  end

  -- 3.  Register language + map to filetypes (parser .so must exist)
  if vim.fn.filereadable(dest) ~= 1 then
    vim.notify('[nvim-iecst] Parser not installed. Run :TSInstall iecst in Neovim.', vim.log.levels.WARN)
    return
  end
  local ok = pcall(vim.treesitter.language.add, 'iecst', { path = dest })
  if not ok then
    vim.notify('[nvim-iecst] Failed to register parser at ' .. dest, vim.log.levels.WARN)
    return
  end
  vim.treesitter.language.register('iecst', { 'iecst' })

  -- 4.  Register parser with nvim-treesitter so queries take effect
  local has_ts = pcall(require, 'nvim-treesitter.configs')
  if has_ts then
    -- Expose parser to nvim-treesitter: queries on rtp are picked up
    require('nvim-treesitter.parsers').iecst = {
      install_info = {}
    }

    -- Load highlight queries for iecst (suppresses "skipping unsupported language" warning)
    vim.schedule(function()
      for _, group in ipairs { 'highlights', 'folds', 'indents', 'locals', 'injections', 'tags' } do
        pcall(vim.treesitter.query.set, 'iecst', group, '')
      end
      vim.cmd('silent! redraw!')
    end)
  end

  -- 5.  Apply default highlight groups (survives colorscheme changes)
  if config.highlight and config.highlight.enable ~= false then
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('IecstColors', { clear = true }),
      callback = function()
        require('iecst.highlights').apply()
      end,
    })
    -- Also apply immediately (in case theme is already loaded)
    vim.schedule(function() require('iecst.highlights').apply() end)
  end

  -- 6.  Auto-commands for filetype settings
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'iecst',
    callback = function()
      vim.bo.expandtab      = true
      vim.bo.shiftwidth     = 4
      vim.bo.tabstop        = 4
      vim.bo.softtabstop    = 4
      vim.bo.commentstring  = '// %s'
      if config.fold and config.fold.enable then
        vim.wo.foldmethod   = 'expr'
        vim.wo.foldexpr     = 'nvim_treesitter#foldexpr()'
        vim.wo.foldminlines = 1
      end
    end,
  })
end

return M
