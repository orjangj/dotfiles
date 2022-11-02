local name = "polar" -- "nord", "nightfox", "polar"
local status_ok, colorscheme = pcall(require, name)

if not status_ok then
  vim.notify(string.format("failed to load colorscheme: %s", name))
  vim.cmd([[
  colorscheme default
  set background=dark
  ]])
  return
end

if name == "polar" then
  colorscheme.setup({ --[[options]] })
end

vim.cmd("colorscheme " .. name)
