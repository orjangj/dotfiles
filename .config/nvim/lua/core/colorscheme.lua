-- NOTE: the plugin is named nightfox (nordfox is part of the collection)
local status_ok, nordfox = pcall(require, "nightfox")

if not status_ok then
  vim.cmd([[
  colorscheme default
  set background=dark
  ]])
  return
end

-- TODO:
-- Only use red and yellow for diagnostics coloring
-- Signcolumn/split color is weird
-- Status line is also weird ... seems like it's black (alternate background color?)
nordfox.setup({
  options = {
    transparent = false, -- Disable (true) setting background
    terminal_colors = true, -- Set (true) terminal colors (vim.g.terminal_color_*) used in `:terminal`
    styles = { -- Value is any valid attr-list value `:help attr-list`
      comments = "italic",
    },
    modules = { -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = {
    nordfox = {
      -- Reference for dark ambiance designs
      -- POLAR NIGHT PALETTE
      -- nord0  = "#2e3440"  -- UI: background and area coloring.
      -- nord1  = "#3b4252"  -- UI: Status bar, text editor gutter, panels, modals, floating popups, etc.
      -- nord2  = "#434c5e"  -- UI: currently active text editor line.
      -- nord3  = "#4c566a"  -- UI: Indent- and wrap guide marker.
      --                     -- Syntax: Comments, invisible/non-printable characters.
      -- SNOW STORM PALETTE
      -- nord4  = "#d8dee9"  -- UI: Things like text-editor caret.
      --                     -- Syntax: variables, constants, attributes and fields.
      -- nord5  = "#e5e9f0"  -- UI: Subtle text elements.
      -- nord6  = "#eceff4"  -- UI: Elevated text elements.
      --                     -- Syntax: Plain text color, structuring characters like curly and square brackets.
      -- FROST PALETTE
      -- nord7  = "#8fbcbb"  -- UI: Accent of nord8 (stand out).
      --                     -- Syntax: Classes, types, primitives.
      -- nord8  = "#88c0d0"  -- UI: Primary elements.
      --                     -- Syntax: declarations, calls and exec of funcs, methods and routines.
      -- nord9  = "#81a1c1"  -- UI: Secondary elements.
      --                     -- Syntax: language specific, syntactic and reserved keywords (i.e. operators, tags, units, ...)
      -- nord10 = "#5e81ac"  -- UI: Tertiary elements (stand out)
      --                     -- Syntax: pragmas, comment keywords, pre-processor statements
      -- AURORA PALETTE
      -- nord11 = "#bf616a"  -- UI: Error states, linter markers, git diff, etc ...
      --                     -- Syntax: Override highlighting of elements that are detected as errors.
      -- nord12 = "#d08770"  -- UI: Rarely used (may indicate advanced/dangerous functionality)
      --                     -- Syntax: Annotations and decorators
      -- nord13 = "#ebcb8b"  -- UI: Warning states, linter markers, git diff, etc ...
      --                     -- Syntax: Override highlighting of elements that are detected as warnings.
      -- nord14 = "#a3be8c"  -- UI: Success states, linter markers, git diff, etc ...
      --                     -- Syntax: Main color for strings of any type (i.e. double/single quited or interpolated)
      -- nord15 = "#b48ead"  -- UI: Rarely used (May indicate uncommon functionality)
      --                     -- Syntax: Main color for numbers of any type like integers and floating point numbers.
      bg0 = "#2e3440",
    },
  },
  specs = {
    nordfox = {
      -- TODO: reuse palette?
      syntax = {
        bracket = "#eceff4",
        builtin0 = "#81a1c1", -- C++: this. Lua: function, require,
        builtin1 = "#8fbcbb", -- C++: namespace names
        builtin2 = "#b48ead", -- C++: NULL, Lua: nil
        builtin3 = "#b48ead", -- TODO: ???
        -- comment string     -- Default is fine. It stands out a bit more.
        conditional = "#81a1c1",
        const = "#d8dee9",
        -- dep string         -- TODO: ???
        field = "#d8dee9", -- struct/class/enum variables
        func = "#88c0d0",
        ident = "#d8dee9", -- C++: function parameters
        keyword = "#81a1c1",
        number = "#b48ead",
        operator = "#81a1c1",
        preproc = "#5e81ac",
        -- regex string -- TODO: ???
        -- statement string -- TODO: ???
        string = "#a3be8c",
        type = "#8fbcbb",
        variable = "#d8dee9",
      },
    },
  },
  groups = {},
})

-- NOTE: May increase startup time a bit (not tested)
nordfox.clean()
nordfox.compile()

vim.cmd("colorscheme nordfox")
