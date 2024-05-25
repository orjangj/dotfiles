return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          -- "comment", -- Makes nvim extremely slow on files with a lot of (long) comments
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
          "norg",
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
        },
        sync_install = true,
        auto_install = false,
        ignore_install = { "" }, -- List of parsers to ignore installing
        highlight = {
          enable = true,
          disable = function(_, buf)
            return vim.api.nvim_buf_line_count(buf) > 10000
          end,
        },
        autopairs = { enable = true },
        indent = { enable = true, disable = { "python" } },
      })
    end,
  },
  { "martinda/Jenkinsfile-vim-syntax", ft = "Jenkinsfile" },
}
