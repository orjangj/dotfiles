return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    -- Only description to let lazy.nvim lazy load it
      { [[<c-t>]], desc = "Toggle terminal" },
  },
  opts = {
    direction = "vertical",
    size = function(term)
      local scaling = 0.4
      if term.direction == "horizontal" then
        return vim.o.lines * scaling
      elseif term.direction == "vertical" then
        return vim.o.columns * scaling
      else
        return 80
      end
    end,
    on_open = function(term)
      local min_width = 70
      local scaling = 0.4
      if vim.o.columns * scaling < min_width then
        term.direction = "horizontal"
      else
        term.direction = "vertical"
      end
    end,
    open_mapping = [[<c-t>]],
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = false,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- TODO: move to lazy spec init?
    function _G.set_terminal_keymaps()
      local settings = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], settings)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], settings)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], settings)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], settings)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], settings)
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
