" nvim-iecst/plugin/iecst.vim
" Bootstrap: guard + command only.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

command! -bar IECSTSetup lua require('iecst').setup()
