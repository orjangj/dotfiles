return {
  "orjangj/polar.nvim",
  config = function()
    require("polar").setup({})
    vim.cmd("colorscheme polar")
  end,
}
