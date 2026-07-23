" nvim-iecst/plugin/iecst.vim
" Bootstrap: expose Lua module + register filetype patterns.
"
" Filetype patterns MUST be set at startup (not in config()) so .st
" files are detected as 'iecst' before lazy.nvim checks ft=.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

command! -bar IECSTSetup lua require('iecst').setup()

lua require('iecst.filetype').setup()
