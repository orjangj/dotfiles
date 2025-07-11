return {
  "orjangj/polar.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("polar").setup({})
    vim.cmd("colorscheme polar")
  end,
}
