return {
  -- {{{ Gitsigns
  {
    -- TODO: detached work tree, and integrations with other plugins
    "lewis6991/gitsigns.nvim",
    commit = "d6a3bf0b36b7e0f09e39f738f9f87ab1e3c450dc", -- NOTE: See https://github.com/lewis6991/gitsigns.nvim/issues/1020
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "│" },
        untracked = { text = "┆" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 50,
        ignore_whitespace = false,
      },
      current_line_blame_formatter_opts = {
        relative_time = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = {
        enable = false,
      },
      worktrees = {
        {
          toplevel = vim.env.HOME,
          gitdir = vim.env.HOME .. "/dotfiles", -- dotfiles bare repo
        },
      },
    },
  },
  -- }}}
  -- {{{ Lazygit
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- TODO: telescope integration?
    },
  },
  -- }}}
}
