return {
  "orjangj/polar.nvim",
  dev = vim.fn.isdirectory("~/projects/git/polar.nvim") and true or false,
  lazy = false,
  priority = 1000,
  config = function()
    require("polar").setup({})
    vim.cmd("colorscheme polar")
  end,
}
