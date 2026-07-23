# IECST Lang Support — IEC 61131-3 Structured Text for Neovim

Syntax highlighting, folding, indentation, and code navigation for IEC 61131-3
Structured Text (CODESYS dialect) in Neovim via tree-sitter.

## Project structure

```
IECST_Lang_Support/
├── lua/iecst/              # Core Lua modules
│   ├── init.lua            #   Entry point: setup()
│   ├── config.lua          #   Default configuration
│   ├── filetype.lua        #   Auto-detection (.st, .ST, .iecst, .IECST)
│   ├── highlights.lua      #   Default highlight groups
│   └── treesitter.lua      #   Treesitter registration
├── plugin/iecst.vim         # Bootstrap + :IECSTSetup command
├── ftplugin/iecst.lua       # Filetype settings (foldmethod)
├── queries/iecst/           # 6 tree-sitter queries
│   ├── highlights.scm       #   197 capture rules
│   ├── folds.scm
│   ├── indents.scm
│   ├── injections.scm
│   ├── locals.scm
│   └── tags.scm
├── doc/iecst.txt            # :help documentation
├── lazy-snippet.lua         # Lazy.nvim one-liner install snippet
└── README.md
```

## Installation

### One command (curl)

```bash
curl -fLo ~/.config/nvim/lua/plugins/iecst.lua \
  https://raw.githubusercontent.com/terlim/IECST_LANG_SUPPORT/main/lazy-snippet.lua
```

Restart Neovim, open any `.st` file, run `:TSInstall iecst` — done.

### Manual (lazy.nvim)

```lua
{
  'terlim/IECST_LANG_SUPPORT',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'iecst', 'st' },
  config = function()
    require('iecst').setup()
  end,
}
```

**With auto-install parser:**
```lua
{
  'terlim/IECST_LANG_SUPPORT',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter',
      opts = { ensure_installed = { 'iecst' } },
    },
  },
  ft = { 'iecst', 'st' },
  config = function()
    require('iecst').setup()
  end,
}
```

## Configuration

```lua
require('iecst').setup({
  filetypes = { 'iecst', 'st' },
  highlight = { enable = true },
  indent    = { enable = true },
  fold      = { enable = true },
})
```

## Features

- Full IEC 61131-3:2013 support (POUs, statements, expressions, types)
- CODESYS extensions: VERSION, PERSISTENT, attribute pragmas
- Syntax highlighting (197 capture rules)
- Code folding and auto-indentation
- Go-to-definition and ctags navigation
- Comment injection (TODO/FIXME/NOTE)
- Error-tolerant: highlights correctly on broken code
- Auto-detection: .st, .ST, .iecst, .IECST

## Requirements

- Neovim >= 0.9
- nvim-treesitter

## License

MIT
