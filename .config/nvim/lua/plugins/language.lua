local languages = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "doxygen",
  "html",
  "javascript",
  "json",
  "json5",
  "kconfig",
  "kotlin",
  "lua",
  "make",
  "markdown",
  "meson",
  "python",
  "query",
  "rasi",
  "regex",
  "rst",
  "rust",
  "toml",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = languages,
  callback = function()
    vim.treesitter.start()
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").install(languages)
    end,
  },
  { "martinda/Jenkinsfile-vim-syntax", ft = "Jenkinsfile" },
}
