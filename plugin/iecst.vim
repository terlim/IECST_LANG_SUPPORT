" nvim-iecst/plugin/iecst.vim
" Bootstrap: expose the Lua module so users can `require('iecst')`.
"
" This file is sourced once when Neovim scans `plugin/` at startup.
" It does NOT call `setup()` — the user must do that explicitly.

if exists('g:loaded_iecst')
  finish
endif
let g:loaded_iecst = 1

" Provide a convenience command to call setup with defaults.
command! -bar IECSTSetup lua require('iecst').setup()
