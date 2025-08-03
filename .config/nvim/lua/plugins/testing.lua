return {
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = {
      { "nvim-neotest/nvim-nio" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "orjangj/neotest-ctest" },
      {
        "andythigpen/nvim-coverage",
        opts = {
          auto_reload = true,
          auto_reload_timeout_ms = 500,
          -- TODO: lcov_file option?
          lang = {
            python = {
              -- FIX: See https://github.com/andythigpen/nvim-coverage/issues/3
              coverage_command = "coverage json --fail-under=0 -q -o -",
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ta", function() require('neotest').run.attach() end,                  desc = "Attach" },
      { "<leader>td", function() require('neotest').run.run({ strategy = 'dap' }) end, desc = "Debug" },
      { "<leader>tc", function() require('coverage').load(true) end,                   desc = "Show Coverage" },
      {
        "<leader>tC",
        function()
          require('coverage').load(true)
          require('coverage').summary()
        end,
        desc = "Coverage Summary"
      },
      { "<leader>tf", function() require('neotest').run.run(vim.fn.expand('%')) end,      desc = "File" },
      { "<leader>tj", function() require('neotest').jump.next({ status = 'failed' }) end, desc = "Next Failed" },
      { "<leader>tk", function() require('neotest').jump.prev({ status = 'failed' }) end, desc = "Prev Failed" },
      { "<leader>tr", function() require('neotest').output.open() end,                    desc = "Results" },
      { "<leader>ts", function() require('neotest').summary.toggle() end,                 desc = "Summary" },
      { "<leader>tt", function() require('neotest').run.run() end,                        desc = "Run Nearest" },
      -- WARNING: Will produce error unless executed inside a file containing tests
      { "<leader>tw", function() require('neotest').run.run({ suite = true }) end,        desc = "Workspace" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            args = function()
              -- TODO: The coverage module doesn't create the coverage report, so we'll have to use neotest for that.
              -- Unfortunately, coverage plugin does not provide docs/suggestions for how to do that.
              -- See https://stackoverflow.com/questions/46652192/py-test-gives-coverage-py-warning-module-sample-py-was-never-imported
              -- TODO: This currently makes pytest-cov or coverage.py generate errors if tests are run on file-level
              return { "--log-level", "DEBUG", "--cov", "./", "--cov-append", "--cov-branch" }
            end,
          }),
          require("neotest-plenary"),
          require("neotest-ctest"),
        },
        status = {
          virtual_text = true,
        },
        icons = {
          failed = " ",
          passed = " ",
          running = " ",
          skipped = " ",
          unknown = " ",
        },
      }
    end,
  },
}
