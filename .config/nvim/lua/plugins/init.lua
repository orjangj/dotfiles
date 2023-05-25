-- NOTE: All additional *.lua files in this directory is merged with
-- the following table (thanks to lazy.nvim).
return {
  { "nvim-lua/plenary.nvim" }, -- Needed by most plugins
  { "MunifTanjim/nui.nvim" },
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
