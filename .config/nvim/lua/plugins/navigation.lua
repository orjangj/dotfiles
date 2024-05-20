return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = function()
      local harpoon = require("harpoon")
      -- stylua: ignore
      return {
        { "<leader>j1", function() harpoon:list():select(1) end, desc = "Harpoon buffer 1" },
        { "<leader>j2", function() harpoon:list():select(2) end, desc = "Harpoon buffer 2" },
        { "<leader>j3", function() harpoon:list():select(3) end, desc = "Harpoon buffer 3" },
        { "<leader>j4", function() harpoon:list():select(4) end, desc = "Harpoon buffer 4" },
        { "<leader>jh", function() harpoon:list():next() end, desc = "Harpoon next buffer" },
        { "<leader>jl", function() harpoon:list():prev() end, desc = "Harpoon prev buffer" },
        { "<leader>jj", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Toggle Menu" },
        { "<leader>ja", function() harpoon:list():add() end, desc = "Harpoon add file" },
        { "<leader>jc", function() harpoon:list():clear() end, desc = "Clear all harpoons" },
      }
    end,
    -- TODO: Some of these settings seem deprecated
    opts = function(_, opts)
      opts.settings = {
        save_on_toggle = false,
        sync_on_ui_close = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
        mark_branch = true, -- FIX: Doesn't seem to work (related? https://github.com/ThePrimeagen/harpoon/issues/565)
        key = function()
          return vim.loop.cwd()
        end,
      }
    end,
    config = function(_, opts)
      require("harpoon").setup(opts)
    end,
  },
}
