local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

toggleterm.setup({
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    winblend = 0,
  },
  highlights = {
    FloatBorder = {
      guifg = vim.api.nvim_get_hl_by_name("FloatBorder", true).foreground }
  }
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
local lazygit_dotfiles = Terminal:new({ cmd = "lazygit --git-dir=$HOME/dotfiles --work-tree=$HOME" })

function _LAZYGIT_TOGGLE()
  -- Not sure if this is the best approach to figure out how to open lazygit for dotfiles as bare repo.
  -- But it works... so why not, eh? Anyway, this only works for tracked files, so adding untracked files
  -- still has to be done outside of nvim.
  local is_dotfile = "false"
  local command = "git --git-dir=$HOME/dotfiles --work-tree=$HOME ls-files --error-unmatch "
    .. vim.api.nvim_buf_get_name(0)
    .. " > /dev/null && echo -n 'true' || echo -n 'false'"
  local handle = io.popen(command)
  if handle then
    is_dotfile = handle:read("*a")
    handle:close()
  end

  if is_dotfile == "true" then
    lazygit_dotfiles:toggle()
  else
    lazygit:toggle()
  end
end

local htop = Terminal:new({ cmd = "htop", hidden = true })

function _HTOP_TOGGLE()
  htop:toggle()
end

local python = Terminal:new({ cmd = "python", hidden = true })

function _PYTHON_TOGGLE()
  python:toggle()
end
