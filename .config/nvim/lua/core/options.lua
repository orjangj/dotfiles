-- These settings applies globally to all files (some settings may be overriden by a ftplugin)
-- see lua/core/autocommands.lua for some settings being overriden by autocommands.
-- See :help options for more options
local options = {
  -- File management
  backup = false,                          -- creates a backup file
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  swapfile = false,                        -- Don't create swapfile (important when editing encrypted files containing secrets)
  writebackup = false,                     -- Dissallow saving file if file is/was edited by another program
  wrap = false,                            -- display lines as one long line
  undofile = true,                         -- enable persistent undo
  -- Split/window management
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  -- Statusline, commandline, columns and cursor
  cursorline = true,                       -- highlight the current line
  cmdheight = 2,                           -- more space in the command line for displaying messages
  number = true,                           -- set numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  relativenumber = true,                   -- set relative numbered lines
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  -- Searching
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  smartcase = true,                        -- smart case
  -- Indentation
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 4,                          -- the number of spaces inserted for each indentation
  showtabline = 4,                         -- always show tabs
  smartindent = true,                      -- make indenting smarter again
  tabstop = 4,                             -- insert spaces for a tab
  -- Completion
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  pumheight = 10,                          -- pop up menu height
  updatetime = 300,                        -- faster completion (4000ms default)
  timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  -- Other
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  scrolloff = 8,
  sidescrolloff = 8,
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  -- Folding
  foldenable = true,
  foldlevel = 0,
  foldmethod = "marker",
}

-- Don't give ins-completion-menu messages
vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
