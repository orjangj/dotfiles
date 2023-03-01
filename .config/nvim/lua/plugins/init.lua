-- NOTE: All additional *.lua files in this directory is merged with
-- the following table (thanks to lazy.nvim).
return {
  { "nvim-lua/plenary.nvim" }, -- Needed by most plugins
  { "gpanders/editorconfig.nvim" }, -- Can be removed if nvim >=v0.9
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
