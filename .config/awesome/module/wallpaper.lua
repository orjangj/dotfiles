local M = {}

-- Get the list of files from a directory. Must be all images or folders and non-empty.
local function scandir(directory)
  local files = {}
  local popen = io.popen

  for filename in popen([[find "]] .. directory .. [[" -type f]]):lines() do
    files[#files + 1] = filename
  end

  return files
end

function M.random(directory)
  local wallpapers = scandir(directory)
  math.randomseed(os.time())
  return wallpapers[math.random(1, #wallpapers)]
end

return M
