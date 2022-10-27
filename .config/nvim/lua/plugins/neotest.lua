local neotest_exists, neotest = pcall(require, "neotest")
if not neotest_exists then
  return
end

local coverage_exists, coverage = pcall(require, "coverage")
if coverage_exists then
  coverage.setup({
    auto_reload = true,
    auto_reload_timeout_ms = 500,
    lang = {
      python = {
        -- See https://github.com/andythigpen/nvim-coverage/issues/3
        coverage_command = "coverage json --fail-under=0 -q -o -",
      },
    },
  })
end

neotest.setup({
--  log_level = "debug",
  status = {
    virtual_text = true,
  },
  adapters = {
    require("neotest-python")({
      args = function()
        if coverage then
          -- See https://stackoverflow.com/questions/46652192/py-test-gives-coverage-py-warning-module-sample-py-was-never-imported
          -- The coverage module doesn't create the coverage report, so we'll have to use neotest for that.
          -- Unfortunately, coverage plugin does not provide docs/suggestions for how to do that
          -- TODO This currently makes pytest-cov or coverage.py generate errors if tests are run on file-level
          return { "--log-level", "DEBUG", "--cov", "./", "--cov-append", "--cov-branch" }
        else
          return { "--log-level", "DEBUG" }
        end
      end,
    }),
    require("neotest-plenary"),
    require("neotest-ctest"),
  },
  icons = {
    failed = " ",
    passed = " ",
    running = " ",
    skipped = " ",
    unknown = " ",
  },
  -- TODO highlights -- Nord colorscheme isn't compatible with neotest at the moment
  -- Should probably create a feature request from nord.nvim to add support for neotest.
--  highlights = {
--    passed = "healthSuccess",
--    failed = "healthError",
--    namespace = "Directory",
--    file = "NvimTreeRootFolder",
--    dir = "Directory",
--    adapter_name = "NvimTreeFolderName",
--  },
})
