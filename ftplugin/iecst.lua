-- ftplugin/iecst.lua
-- IECST filetype settings — applied after treesitter has loaded.

-- Fold method: use treesitter when available
if pcall(require, 'nvim-treesitter') then
  vim.wo.foldmethod   = 'expr'
  vim.wo.foldexpr     = 'nvim_treesitter#foldexpr()'
  vim.wo.foldminlines = 1
end
