" nvim-iecst/plugin/iecst.vim
" Bootstrap: expose Lua module + register parser with nvim-treesitter.
"
" This file is sourced once when Neovim scans `plugin/` at startup.
" Parser registration MUST happen here (before nvim-treesitter loads)
" so that `:TSInstall iecst` works.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

" Provide a convenience command to call setup with defaults.
command! -bar IECSTSetup lua require('iecst').setup()

lua << EOF
-- Register the parser with nvim-treesitter so :TSInstall iecst knows
-- where to clone it from. Must happen before nvim-treesitter parses
-- its ensure_installed list.
local function register_parser()
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

  parsers.iecst = parser_def
  -- Compatibility with older nvim-treesitter:
  pcall(function()
    parsers.get_parser_configs().iecst = parser_def
  end)
  -- Map parser name to filetype:
  pcall(vim.treesitter.language.register, 'iecst', { 'iecst' })
end

-- Try immediately (if nvim-treesitter is already loaded)
register_parser()
-- Also try after VimEnter (if nvim-treesitter loads later)
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = register_parser,
})
EOF
