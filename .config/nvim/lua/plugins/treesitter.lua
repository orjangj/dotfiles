return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    { "nvim-lua/plenary.nvim" }, -- Required by most plugins
    { "nvim-treesitter/playground" },
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "dockerfile",
        "help",
        "json",
        "lua",
        "make",
        "markdown",
        "norg",
        "python",
        "query",
        "rasi",
        "regex",
        "rst",
        "rust",
        "toml",
        "vim",
        "yaml",
      },
      ignore_install = { "" }, -- List of parsers to ignore installing
      highlight = { enable = true },
      autopairs = { enable = true },
      indent = { enable = true, disable = { "python" } },
    })
  end,
}
