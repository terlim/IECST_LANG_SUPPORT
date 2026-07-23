" nvim-iecst/plugin/iecst.vim
" Bootstrap: expose Lua module + register parser with nvim-treesitter.
"
" This file is sourced once when Neovim scans `plugin/` at startup.
" Parser MUST be registered here so :TSInstall knows the grammar URL.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

command! -bar IECSTSetup lua require('iecst').setup()

lua require('iecst.treesitter').setup(require('iecst.config').defaults)
