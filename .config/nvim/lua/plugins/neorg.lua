local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

neorg.setup({
  load = {
    ["core.defaults"] = {},
    ["core.norg.concealer"] = {
      config = {
        folds = false, -- doesn't play nicely with presenter mode
      },
    },
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
        autochdir = false,
        workspaces = {
          work = "~/notes/work",
          personal = "~/notes/personal",
          gtd = "~/notes/gtd",
        },
      },
    },
  },
})
