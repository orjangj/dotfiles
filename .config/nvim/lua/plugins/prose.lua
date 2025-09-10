return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = ":call mkdp#util#install()",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      file_types = { "markdown", "copilot-chat" },
      heading = {
        sign = false,
      },
      code = {
        border = "thin",
        sign = false,
        highlight_language = "Comment",
      },
    },
    ft = { "markdown", "copilot-chat" },
  },
}
