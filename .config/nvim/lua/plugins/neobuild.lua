return {
  "orjangj/neobuild",
  dev = vim.fn.isdirectory("~/projects/git/neobuild") and true or false,
  config = function()
    require("neobuild").setup({})
  end,
}
