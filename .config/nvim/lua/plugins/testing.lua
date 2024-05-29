return {
  -- TODO: Need to update config?
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-neotest/nvim-nio" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "andythigpen/nvim-coverage" },
      -- TODO: Make sure neotest-ctest still works
      { "orjangj/neotest-ctest" },
    },
    keys = function()
      local neotest = require("neotest")
      local coverage = require("coverage")

      -- stylua: ignore
      -- TODO: Is there a way to specify test suite (namespace)?
      return {
        { "<leader>ta", function() neotest.run.attach() end,                     desc = "Attach" },
        { "<leader>td", function() neotest.run.run({ strategy = 'dap' }) end,    desc = "Debug" },
        -- WARNING: Currently relies on either (1) manually executing CoverageLoad, or execute neotest on entire workspace.
        -- Not all adapters (i.e. pytest) makes it easy to isolate coverage report without knowing what modules are tested.
        -- Maybe there's a more elegant solution here, but this seems to work quite well.
        { "<leader>tc", function() coverage.summary() end,                       desc = "Coverage" },
        { "<leader>tf", function() neotest.run.run(vim.fn.expand('%')) end,      desc = "File" },
        { "<leader>tj", function() neotest.jump.next({ status = 'failed' }) end, desc = "Next Failed" },
        { "<leader>tk", function() neotest.jump.prev({ status = 'failed' }) end, desc = "Prev Failed" },
        { "<leader>tr", function() neotest.output.open() end,                    desc = "Results" },
        { "<leader>ts", function() neotest.summary.toggle() end,                 desc = "Summary" },
        { "<leader>tt", function() neotest.run.run() end,                        desc = "Run Nearest" },
        -- WARNING: Will produce error unless executed inside a file containing tests
        -- To be able to execute this without having to go through a test file, the adapter option must be set.
        -- The adapter arg expects "adapter_name:root_dir" as adapter_id. Might want to check if a lua function
        -- can be used to figure this out based on e.g. file extension. Ex: python files would specify neotest-python.
        -- example: lua require('neotest').run.run({ suite = true, adapter = 'neotest-python:/home/og/projects/personal/nvim-demo/python' })
        { "<leader>tw", function() neotest.run.run({ suite = true }) end,        desc = "Workspace" },
      }
    end,
    -- TODO: update config?
    config = function()
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

      require("neotest").setup({
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
                -- TODO: This currently makes pytest-cov or coverage.py generate errors if tests are run on file-level
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
      })
    end,
  },
}
