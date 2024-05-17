local naughty = require("naughty")

local M = {}

function M.debug(message)
  naughty.notify({
    title = "Debug",
    text = message
  })
end

function M.strsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function M.isempty(t)
  return next(t) == nil
end

return M
