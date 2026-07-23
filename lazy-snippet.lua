-- nvim-iecst: Lazy.nvim installation snippet

return {
  {
    'terlim/IECST_LANG_SUPPORT',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'iecst' },
    config = function()
      require('iecst').setup()
    end,
  },
}
