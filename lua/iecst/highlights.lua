-- nvim-iecst/lua/iecst/highlights.lua
-- Default highlight groups for IECST (IEC 61131-3 Structured Text).
--
-- Applied on every `ColorScheme` event so the defaults survive theme switches.
-- Users can override by setting `config.highlight = false` or by redefining
-- the groups in their own `ColorScheme` autocmd.

local M = {}

-- Named palette — users can override a subset and leave the rest.
M.palette = {
  comment              = { fg = '#6A9955', italic = true },
  attribute            = { fg = '#C586C0', italic = true },
  boolean              = { fg = '#569CD6' },
  number               = { fg = '#B5CEA8' },
  ['number.float']     = { link = 'IecstNumber' },
  string               = { fg = '#CE9178' },
  ['string.special']   = { fg = '#D7BA7D' },
  type                 = { fg = '#4EC9B0' },
  ['type.builtin']     = { fg = '#4EC9B0', bold = true },
  ['function']          = { fg = '#DCDCAA' },
  ['function.method']  = { fg = '#DCDCAA' },
  ['function.call']    = { fg = '#DCDCAA' },
  property             = { fg = '#9CDCFE' },
  namespace            = { fg = '#4EC9B0', italic = true },
  variable             = { fg = '#9CDCFE' },
  ['variable.builtin'] = { fg = '#569CD6' },
  field                = { fg = '#9CDCFE' },
  constant             = { fg = '#4FC1FF' },
  ['constant.builtin'] = { fg = '#4FC1FF', bold = true },
  parameter            = { fg = '#9CDCFE', italic = true },
  keyword              = { fg = '#C586C0' },
  ['keyword.control']  = { fg = '#C586C0', bold = true },
  ['keyword.modifier'] = { fg = '#C586C0' },
  ['keyword.operator'] = { fg = '#569CD6' },
  operator             = { fg = '#D4D4D4' },
  ['punctuation.bracket']   = { fg = '#D4D4D4' },
  ['punctuation.delimiter'] = { fg = '#D4D4D4' },
  ['punctuation.special']   = { fg = '#D4D4D4' },
}

-- Map palette keys → Neovim highlight group names.
-- Keys match the tree-sitter capture names, with `.` → `_`.
local GROUP_MAP = {
  attribute              = 'IecstAttribute',
  boolean                = 'IecstBoolean',
  comment                = 'IecstComment',
  constant               = 'IecstConstant',
  ['constant.builtin']   = 'IecstConstantBuiltin',
  field                  = 'IecstField',
  ['function']            = 'IecstFunction',
  ['function.call']      = 'IecstFunctionCall',
  ['function.method']    = 'IecstFunctionMethod',
  keyword                = 'IecstKeyword',
  ['keyword.control']    = 'IecstKeywordControl',
  ['keyword.modifier']   = 'IecstKeywordModifier',
  ['keyword.operator']   = 'IecstKeywordOperator',
  namespace             = 'IecstNamespace',
  number                = 'IecstNumber',
  ['number.float']       = 'IecstNumberFloat',
  operator              = 'IecstOperator',
  parameter             = 'IecstParameter',
  property              = 'IecstProperty',
  ['punctuation.bracket'] = 'IecstPunctuationBracket',
  ['punctuation.delimiter'] = 'IecstPunctuationDelimiter',
  ['punctuation.special'] = 'IecstPunctuationSpecial',
  string_literal         = 'IecstString',
  string                 = 'IecstString',  -- palette key is 'string'
  ['string.special']     = 'IecstStringSpecial',
  type                   = 'IecstType',
  ['type.builtin']       = 'IecstTypeBuiltin',
  variable               = 'IecstVariable',
  ['variable.builtin']   = 'IecstVariableBuiltin',
}

-- Mappings: capture-name → highlight group (for tree-sitter query linking).
local CAPTURE_TO_GROUP = {
  ['@comment']                       = '@IecstComment',
  ['@attribute']                     = '@IecstAttribute',
  ['@boolean']                       = '@IecstBoolean',
  ['@number']                        = '@IecstNumber',
  ['@number.float']                  = '@IecstNumberFloat',
  ['@string']                        = '@IecstString',
  ['@string.special']                = '@IecstStringSpecial',
  ['@type']                          = '@IecstType',
  ['@type.builtin']                  = '@IecstTypeBuiltin',
  ['@function']                      = '@IecstFunction',
  ['@function.call']                 = '@IecstFunctionCall',
  ['@function.method']               = '@IecstFunctionMethod',
  ['@property']                      = '@IecstProperty',
  ['@namespace']                     = '@IecstNamespace',
  ['@variable']                      = '@IecstVariable',
  ['@variable.builtin']              = '@IecstVariableBuiltin',
  ['@field']                         = '@IecstField',
  ['@constant']                      = '@IecstConstant',
  ['@constant.builtin']              = '@IecstConstantBuiltin',
  ['@parameter']                     = '@IecstParameter',
  ['@keyword']                       = '@IecstKeyword',
  ['@keyword.control']               = '@IecstKeywordControl',
  ['@keyword.modifier']              = '@IecstKeywordModifier',
  ['@keyword.operator']              = '@IecstKeywordOperator',
  ['@operator']                      = '@IecstOperator',
  ['@punctuation.bracket']           = '@IecstPunctuationBracket',
  ['@punctuation.delimiter']         = '@IecstPunctuationDelimiter',
  ['@punctuation.special']           = '@IecstPunctuationSpecial',
}

--- Set Neovim highlight groups from the palette.
--- Call after the palette has been customised by the user.
function M.apply()
  local function def(name, opts)
    if not name then return end
    pcall(function()
      if opts.link then
        vim.api.nvim_set_hl(0, name, { default = true, link = opts.link })
      else
        vim.api.nvim_set_hl(0, name, vim.tbl_extend('keep', opts, { default = true }))
      end
    end)
  end

  for key, opts in pairs(M.palette) do
    local grp = GROUP_MAP[key]
    if grp then
      def(grp, opts)
    end
  end

  -- Wire tree-sitter capture → highlight group
  for capture, group in pairs(CAPTURE_TO_GROUP) do
    pcall(vim.treesitter.highlighter.hl_map, capture, group)
  end
end

--- Reset to defaults (useful when user sets palette = nil to disable).
function M.reset()
  for _, grp in pairs(GROUP_MAP) do
    pcall(vim.api.nvim_set_hl, 0, grp, { default = true, link = 'NONE' })
  end
  for capture, _ in pairs(CAPTURE_TO_GROUP) do
    pcall(vim.treesitter.highlighter.hl_map, capture, capture)
  end
end

M.GROUP_MAP = GROUP_MAP
M.CAPTURE_TO_GROUP = CAPTURE_TO_GROUP

return M
