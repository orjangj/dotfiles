return {
  {
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local harpoon = require("harpoon")

        -- TODO: How to persist harpooned marks between quit/enter nvim?
        -- TODO: Unique marks per git branch?
        harpoon:setup({})

        -- TODO: Use with whichkey?
        vim.keymap.set("n", "<leader>jj", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<leader>ja", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>j1", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>j2", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>j3", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>j4", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>jh", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<leader>jl", function() harpoon:list():next() end)
      end
    },
  },
}
