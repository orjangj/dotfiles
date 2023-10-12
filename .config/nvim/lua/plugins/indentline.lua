return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    scope = {
      show_start = false,
      highlight = "Label",
      include = {
        node_type = {
          lua = { "return_statement", "table_constructor" },
        },
      },
    },
  },
}
