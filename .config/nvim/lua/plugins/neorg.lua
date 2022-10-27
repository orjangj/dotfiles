local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  return
end

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.mode.events.mode_set", function(_, content)
  if not vim.fn.executable("kitty") then
    return
  end

  -- Entering presenter mode
  -- Set cursor color to match background color to make the cursor invisible
  if content.new == "presenter" then
    local cmd = "kitty @ --to %s set-colors cursor=#2E3440"
    local socket = vim.fn.expand("$KITTY_LISTEN_ON")
    vim.fn.system(cmd:format(socket))
  end

  -- Exiting presenter mode
  if content.current == "presenter" then
    local cmd = "kitty @ --to %s set-colors --reset"
    local socket = vim.fn.expand("$KITTY_LISTEN_ON")
    vim.fn.system(cmd:format(socket))
  end
end)

neorg.setup({
  load = {
    ["core.defaults"] = {},
    ["core.norg.concealer"] = {
      config = {
        folds = false,
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
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd",
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
