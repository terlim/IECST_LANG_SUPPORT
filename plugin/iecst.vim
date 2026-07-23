" nvim-iecst/plugin/iecst.vim
" Bootstrap: expose Lua module + register parser with nvim-treesitter.
"
" This file is sourced once when Neovim scans `plugin/` at startup.
" Parser registration MUST happen here (before `:TSInstall` is called)
" so that nvim-treesitter knows the grammar URL.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

" Provide a convenience command to call setup with defaults.
command! -bar IECSTSetup lua require('iecst').setup()

lua << EOF
-- Register immediately (plugin/ loads after nvim-treesitter in the
-- standard lazy.nvim startup order).
local function register()
  local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not ok then return end

  local config = require('iecst.config').defaults
  local parser_def = {
    install_info = {
      url      = config.parser.url,
      branch   = config.parser.branch,
      files    = { 'src/parser.c', 'src/scanner.c' },
      generate = config.parser.generate,
    },
    filetype = config.parser.filetype,
  }

  -- Direct assignment (works in latest nvim-treesitter)
  parsers.iecst = parser_def
  -- Legacy API (older nvim-treesitter uses this)
  pcall(function()
    parsers.get_parser_configs().iecst = parser_def
  end)
  -- Filetype association
  pcall(vim.treesitter.language.register, 'iecst', { 'iecst' })
end

-- Try now; if nvim-treesitter not loaded yet, defer to VimEnter
if pcall(require, 'nvim-treesitter') then
  register()
else
  vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = register })
end
EOF
