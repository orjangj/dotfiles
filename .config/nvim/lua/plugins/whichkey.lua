local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<cr>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  ["1"] = { "<cmd>ToggleTerm direction=float<cr>", "Terminal (float)" },
  ["2"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Terminal (vertical)" },
  ["3"] = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
  ["4"] = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
  ["c"] = { "<cmd>Bdelete!<cr>", "Close Buffer" },
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["h"] = { "<cmd>nohlsearch<cr>", "No Highlight" },
  ["m"] = { "<cmd>Alpha<cr>", "Main Menu" },
  ["q"] = { "<cmd>q!<cr>", "Quit" },
  ["w"] = { "<cmd>w!<cr>", "Save Buffer" },
  ["z"] = { "<cmd>ZenMode<cr>", "Zen Mode" },
  d = {
    name = "Diagnostics",
    d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer Diagnostics" },
    D = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
    j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
    k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
    t = { "<cmd>TroubleToggle<cr>", "Trouble" },
  },
  g = {
    name = "Git",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame Line" },
    L = { "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>", "Blame Toggle"},
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage buffer" },
    u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    U = { "<cmd>lua require 'gitsigns'.reset_buffer_index()<cr>", "Undo Stage Buffer" },
  },
  f = {
    name = "Find",
    b = {
      "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Buffers",
    },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    f = { "<cmd>Telescope find_files<cr>", "Files" },
    F = { "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>", "Recent Files" },
    g = { "<cmd>Telescope glyph<cr>", "Glyphs" },
    h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
    r = { "<cmd>Telescope lsp_references<cr>", "References" },
    s = { "<cmd>Telescope live_grep<cr>", "Workspace Search" },
    S = { "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>", "Buffer Search" },
    t = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
    z = { "<cmd>Telescope spell_suggest<cr>", "Spelling Suggestions" },
  },
  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    A = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format Buffer" },
    i = { "<cmd>LspInfo<cr>", "List Clients" },
    I = { "<cmd>Mason<cr>", "Installer Info" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
  },
  n = {
    name = "Notes",
    -- TODO: These doesn't work when in a .norg file (conflicting keybinds with neorg)
    n = { "<cmd>Neorg gtd capture<cr>", "New Task" },
    p = { "<cmd>Neorg presenter start<cr>", "Start Presentation" },
    v = { "<cmd>Neorg gtd views<cr>", "View Tasks" },
  },
  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
    z = { "<cmd>PackerSync<cr>", "Sync" },
  },
  t = {
    name = "Test",
    -- TODO: Is there a way to specify test suite (namespace)?
    a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
    d = { "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>", "Debug" },
    -- NOTE: Currently relies on either (1) manually executing CoverageLoad, or execute neotest on entire workspace.
    -- Not all adapters (i.e. pytest) makes it easy to isolate coverage report without knowing what modules are tested.
    -- Maybe there's a more elegant solution here, but this seems to work quite well.
    c = { "<cmd>lua require('coverage').summary()<cr>", "Coverage Summary"},
    f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
    j = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Next Failed Test" },
    k = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Prev Failed Test" },
    r = { "<cmd>lua require('neotest').output.open()<cr>", "Results" },
    s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
    t = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
    -- NOTE: Will produce error unless executed inside a file containing tests
    -- To be able to execute this without having to go through a test file, the adapter option must be set.
    -- The adapter arg expects "adapter_name:root_dir" as adapter_id. Might want to check if a lua function
    -- can be used to figure this out based on e.g. file extension. Ex: python files would specify neotest-python.
    -- example: lua require('neotest').run.run({ suite = true, adapter = 'neotest-python:/home/og/projects/personal/nvim-demo/python' })
    w = { "<cmd>lua require('neotest').run.run({ suite = true })<cr><cmd>lua require('coverage').load(true)<cr>", "Workspace" },
  }
}

which_key.setup(setup)
which_key.register(mappings, opts)
