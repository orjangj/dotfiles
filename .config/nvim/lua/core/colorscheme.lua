local name = "polar" -- "nord", "nightfox", "polar"
local status_ok, colorscheme = pcall(require, name)

if not status_ok then
  vim.notify("Failed to load colorscheme " .. name, vim.log.levels.WARN)
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
