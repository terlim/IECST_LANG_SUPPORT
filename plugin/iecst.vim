" nvim-iecst/plugin/iecst.vim
" Bootstrap: expose Lua module + register parser with nvim-treesitter.
"
" This file is sourced once when Neovim scans `plugin/` at startup.
" Parser registration MUST happen here (before `:TSInstall` is called)
" so that nvim-treesitter knows where to clone the grammar from.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

" Provide a convenience command to call setup with defaults.
command! -bar IECSTSetup lua require('iecst').setup()

lua << EOF
-- Defer registration to when nvim-treesitter triggers its TSUpdate
-- event. This is the only reliable hook that runs before :TSInstall
-- checks the parser list.
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  once = true,
  callback = function()
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

    local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
    if ok then
      parsers.iecst = parser_def
      -- Compatibility with older nvim-treesitter:
      pcall(function()
        parsers.get_parser_configs().iecst = parser_def
      end)
      -- Map parser name -> filetype
      pcall(vim.treesitter.language.register, 'iecst', { 'iecst' })
    end
  end,
})

-- If nvim-treesitter already loaded, fire now
vim.schedule(function()
  pcall(function()
    if package.loaded['nvim-treesitter'] then
      vim.cmd('doautocmd User TSUpdate')
    end
  end)
end)
EOF
