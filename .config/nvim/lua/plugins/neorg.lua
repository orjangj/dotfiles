return {
  "nvim-neorg/neorg",
  dependencies = {
    { "folke/zen-mode.nvim" },
    { "folke/twilight.nvim" },
  },
  build = ":Neorg sync-parsers",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.norg.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
              cookbook = "~/projects/git/cookbook",
            },
            default_workspace = "notes",
          },
        },
      },
    })
  end,
}
