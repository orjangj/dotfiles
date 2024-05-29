return {
  -- {{{ Gitsigns
  {
    -- TODO: detached work tree, and integrations with other plugins
    "lewis6991/gitsigns.nvim",
    commit = "d6a3bf0b36b7e0f09e39f738f9f87ab1e3c450dc", -- NOTE: See https://github.com/lewis6991/gitsigns.nvim/issues/1020
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      -- NOTE: Not sure if this can have any side-effects, but it seems to work :D
      -- Go back to original window with <q> after calling gitsigns.diffthis()
      augroup("closeDiffWithQ", { clear = true })
      autocmd("DiffUpdated", {
        group = "closeDiffWithQ",
        callback = function(event)
          -- Ensure we're actually in a diff (might be redundant, but why not?)
          if vim.opt.diff:get() then
            -- make <q> a oneshot keymap that closes the diff view
            -- and goes back to the original winndow
            vim.keymap.set("n", "q", function()
              vim.cmd("wincmd p | q")
              vim.keymap.del("n", "q", { buffer = event.buf })
            end, { buffer = event.buf, silent = true })
          end
        end,
      })
    end,
    keys = function()
      local gitsigns = require("gitsigns")
      -- stylua: ignore
      return {
        { "<leader>gb", "<cmd>Telescope git_branches<cr>",                   desc = "Checkout branch" },
        { "<leader>gc", "<cmd>Telescope git_commits<cr>",                    desc = "Checkout commit" },
        { "<leader>gd", function() gitsigns.diffthis("HEAD") end,            desc = "Show Diff" },
        { "<leader>gj", function() gitsigns.next_hunk() end,                 desc = "Next Hunk" },
        { "<leader>gk", function() gitsigns.prev_hunk() end,                 desc = "Prev Hunk" },
        { "<leader>gl", function() gitsigns.blame_line() end,                desc = "Blame Line" },
        { "<leader>gL", function() gitsigns.toggle_current_line_blame() end, desc = "Blame Toggle" },
        { "<leader>go", "<cmd>Telescope git_status<cr>",                     desc = "Open changed file" },
        { "<leader>gp", function() gitsigns.preview_hunk() end,              desc = "Preview Hunk" },
        { "<leader>gr", function() gitsigns.reset_hunk() end,                desc = "Reset Hunk" },
        { "<leader>gR", function() gitsigns.reset_buffer() end,              desc = "Reset Buffer" },
        { "<leader>gs", function() gitsigns.stage_hunk() end,                desc = "Stage Hunk" },
        { "<leader>gS", function() gitsigns.stage_buffer() end,              desc = "Stage buffer" },
        { "<leader>gu", function() gitsigns.undo_stage_hunk() end,           desc = "Undo Stage Hunk" },
        { "<leader>gU", function() gitsigns.reset_buffer_index() end,        desc = "Undo Stage Buffer" },
      }
    end,
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
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
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
    -- TODO: Replace with something else? Fugitive or Neogit maybe?
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- TODO: telescope integration?
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  -- }}}
}
