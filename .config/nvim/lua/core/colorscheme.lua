local name = "nightfox" -- "nord", "nightfox"
local status_ok, colorscheme = pcall(require, name)

if not status_ok then
  vim.cmd([[
  colorscheme default
  set background=dark
  ]])
  return
end

if name == "nord" then
  vim.g.nord_borders = true -- Enable the border between vertical split windows
  vim.g.nord_disable_background = true -- Use terminal background color instead
  vim.g.nord_cursorline_transparent = true
  vim.g.nord_enable_sidebar_background = true -- Re-enables bg of sidebar if nord_disable_background is true
  vim.g.nord_uniform_diff_background = true -- Colorful backgrounds when used in diff mode
  vim.cmd("colorscheme nord")
elseif name == "nightfox" then
  -- NOTE: The Plugin is named nightfox, but the name of the nord colorscheme is nordfox
  -- TODO:
  -- GitSigns Line blame ... to dark
  -- Cleanup
  -- dim vs bright vs ...??? see init vs setup in nightfox docs
  -- Reuse palette for spec/group?
  -- Fix highlight for split line (it's black)
  -- Fix highlight for line numbers (and current linenr)
  -- Fix highlight for current line
  -- Fix highlight for git diff view
  -- Fix highlight for visual selection
  -- Fix bg colour for diagnostic virtual text
  name = "nordfox"
  local shade = require("nightfox.lib.shade")
  local options = {
    styles = { -- Value is any valid attr-list value `:help attr-list`
      comments = "italic",
    },
  }
  local palette = {
    -- https://github.com/arcticicestudio/nord
    -- POLAR NIGHT PALETTE
    nord0 = "#2e3440", -- UI: background and area coloring. Syntax: none.
    nord1 = "#3b4252", -- UI: Status bar, panels, floating popups, etc. Syntax: none.
    nord2 = "#434c5e", -- UI: currently active text editor line. Syntax: none.
    nord3 = "#4c566a", -- UI: Indent- and wrap guide marker. Syntax: Comments, invisible/non-printable characters.
    -- SNOW STORM PALETTE
    nord4 = "#d8dee9", -- UI: Things like text-editor caret. Syntax: variables, constants, attributes and fields.
    nord5 = "#e5e9f0", -- UI: Subtle text elements. Syntax: none.
    nord6 = "#eceff4", -- UI: Elevated text elements. Syntax: Plain text color, structuring characters like curly and square brackets.
    -- FROST PALETTE
    nord7 = "#8fbcbb", -- UI: Primary accent/alternate color. Syntax: Classes, types, primitives.
    nord8 = "#88c0d0", -- UI: Primary elements. Syntax: declarations, calls and exec of funcs, methods and routines.
    nord9 = "#81a1c1", -- UI: Secondary elements. Syntax: language specific, syntactic and reserved keywords (i.e. operators, tags, units, ...)
    nord10 = "#5e81ac", -- UI: Tertiary elements. Syntax: pragmas, comment keywords, pre-processor statements
    -- AURORA PALETTE
    nord11 = "#bf616a", -- UI: Error states, linter markers, git diff. Syntax: Override highlighting of elements that are detected as errors.
    nord12 = "#d08770", -- UI: Rarely used. Syntax: Annotations and decorators
    nord13 = "#ebcb8b", -- UI: Warning states, linter markers, git diff. Syntax: Override highlighting of elements that are detected as warnings.
    nord14 = "#a3be8c", -- UI: Success states, linter markers, git diff. Syntax: Main color for strings of any type.
    nord15 = "#b48ead", -- UI: Rarely used. Syntax: Numbers of any type.

    -- shade.new(base, bright, dim, light)
    -- TODO: Specify bright and dim colors using i.e. RGB2HSL and l adjustment and back
    black = shade.new("#3b4252", "#3b4252", "#3b4252"),
    red = shade.new("#bf616a", "#bf616a", "#bf616a"),
    green = shade.new("#a3be8c", "#a3be8c", "#a3be8c"),
    yellow = shade.new("#ebcb8b", "#ebcb8b", "#ebcb8b"),
    blue = shade.new("#81a1c1", "#81a1c1", "#81a1c1"),
    magenta = shade.new("#b48ead", "#b48ead", "#b48ead"),
    cyan = shade.new("#88c0d0", "#88c0d0", "#88c0d0"),
    white = shade.new("#d8dee9", "#d8dee9", "#d8dee9"),
    orange = shade.new("#d08770", "#d08770", "#d08770"),
    pink = shade.new("#bf88af", "#bf88af", "#bf88af"), -- TODO: nord doesn't really specify pink

    comment = "#576279", -- nord3 adjusted by 5% according to https://github.com/arcticicestudio/nord/issues/94

    bg0 = "#2e3440", -- Dark bg (status line and float)
    bg1 = "#2e3440", -- Default bg
    bg2 = "#3b4252", -- Lighter bg (colorcolumn, folds)
    bg3 = "#3b4252", -- Lighter bg (cursor line)
    bg4 = "#434c5e", -- Conceal, border fg

    fg0 = "#eceff4", -- Lighter fg
    fg1 = "#d8dee9", -- Default fg
    fg2 = "#d8dee9", -- Darker fg (status line)
    fg3 = "#576279", -- Darker fg (line numbers, fold columns)

    sel0 = "#3b4252", -- Popup bg, visual selection bg
    sel1 = "#576279", -- Popup sel bg, search bg
  }

  local spec = {
    syntax = {
      bracket = palette.white.base,
      builtin0 = palette.blue.base, -- C++: this. Lua: function, require,
      builtin1 = palette.magenta.base, -- C++: namespace names
      builtin2 = palette.magenta.base, -- C++: NULL, Lua: nil
      builtin3 = palette.magenta.base,
      comment = palette.comment, -- This is nord3 adjusted by 5% according to https://github.com/arcticicestudio/nord/issues/94
      conditional = palette.blue.base,
      const = palette.white.base, -- TODO: another color? applies to enum values?
      dep = palette.magenta.base, -- Deprecated
      field = palette.white.base, -- struct/class/enum variables
      func = palette.cyan.base,
      ident = palette.white.base, -- C++: function parameters
      keyword = palette.blue.base,
      number = palette.magenta.base,
      operator = palette.blue.base,
      preproc = palette.blue.base,
      regex = palette.yellow.base,
      statement = palette.magenta.base,
      string = palette.green.base,
      type = palette.nord7, -- TODO
      variable = palette.white.base,
    },
    git = {
      add = palette.green.base,
      removed = palette.red.base,
      changed = palette.yellow.base,
      conflict = palette.orange.base,
      ignored = palette.comment,
    },
    diag = {
      error = palette.red.base,
      warn = palette.yellow.base,
      info = palette.blue.base,
      hint = palette.white.base,
    },
    diag_bg = {
      error = palette.bg0,
      warn = palette.bg0,
      info = palette.bg0,
      hint = palette.bg0,
    },
    diff = { -- bg color
      add = palette.nord1,
      delete = palette.nord1,
      change = palette.nord1,
      text = palette.nord1,
    },
  }

  local modules = {
    gitsigns = { -- NOTE: nightfox plugin doesn't seem to set all of these
      GitSignsAdd = { fg = spec.git.add }, -- diff mode: Added line |diff.txt|
      GitSignsAddNr = { fg = spec.git.add }, -- diff mode: Added line |diff.txt|
      GitSignsAddLn = { fg = spec.git.add }, -- diff mode: Added line |diff.txt|
      GitSignsChange = { fg = spec.git.changed }, -- diff mode: Changed line |diff.txt|
      GitSignsChangeNr = { fg = spec.git.changed }, -- diff mode: Changed line |diff.txt|
      GitSignsChangeLn = { fg = spec.git.changed }, -- diff mode: Changed line |diff.txt|
      GitSignsDelete = { fg = spec.git.removed }, -- diff mode: Deleted line |diff.txt|
      GitSignsDeleteNr = { fg = spec.git.removed }, -- diff mode: Deleted line |diff.txt|
      GitSignsDeleteLn = { fg = spec.git.removed }, -- diff mode: Deleted line |diff.txt|
      GitSignsCurrentLineBlame = { fg = palette.comment, style = "bold" },
    },
  }

  local groups = {
      -- NOTE: Changed to get highlight of text instead of bg
      DiffAdd = { fg = palette.green.base, bg = palette.nord1 }, -- diff mode: Added line
      DiffChange = { fg = palette.yellow.base, bg = palette.nord1 }, --  diff mode: Changed line
      DiffDelete = { fg = palette.red.base, bg = palette.nord1 }, -- diff mode: Deleted line
      DiffText = { fg = palette.yellow.base, bg = palette.nord1 }, -- diff mode: Changed text within a changed line
  }

  colorscheme.setup({
    options = options,
    modules = modules,
    palettes = { nordfox = palette },
    specs = { nordfox = spec },
    groups = { nordfox = groups },
  })

  -- NOTE: Enable these if necessary
  colorscheme.clean()
  colorscheme.compile()
  vim.cmd("colorscheme " .. name)
end

vim.cmd("colorscheme " .. name)
