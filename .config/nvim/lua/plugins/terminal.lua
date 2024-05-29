return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    -- Only description to let lazy.nvim lazy load it
    { [[<c-\>]], desc = "Toggle terminal" },
  },
  opts = {
      size = function(term)
        if term.direction == "float" then
          return 80
        else
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
      direction = "vertical",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
      highlights = {
        FloatBorder = {
          guifg = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg,
        },
      },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- TODO: move to lazy spec init?
    function _G.set_terminal_keymaps()
      local settings = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], settings )
      vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], settings )
      vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], settings )
      vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], settings )
      vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], settings )
    end
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
