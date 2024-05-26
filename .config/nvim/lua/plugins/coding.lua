return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from pattern match
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      scope = {
        show_start = false,
        highlight = "Label",
        include = {
          node_type = {
            lua = { "return_statement", "table_constructor" },
          },
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX<cr>", desc = "TODO" },
    },
    opts = {
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--glob=!{submodules}", -- Don't search in these folders
        },
        pattern = [[\b(KEYWORDS):]],
      },
    },
  },
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
      { "orjangj/neotest-ctest" },
    },
    keys = function()
      local neotest = require("neotest")
      local coverage = require("coverage")

      local success, wk = pcall(require, "which-key")
      if success then
        wk.register({
          mode = { "n", "v" },
          ["<leader>t"] = { name = "Test" },
        })
      end

      -- stylua: ignore
      -- TODO: Is there a way to specify test suite (namespace)?
      return {
        { "<leader>ta", function() neotest.run.attach() end,                    desc = "Attach" },
        { "<leader>td", function() neotest.run.run({ strategy = 'dap' }) end,   desc = "Debug" },
        -- NOTE: Currently relies on either (1) manually executing CoverageLoad, or execute neotest on entire workspace.
        -- Not all adapters (i.e. pytest) makes it easy to isolate coverage report without knowing what modules are tested.
        -- Maybe there's a more elegant solution here, but this seems to work quite well.
        { "<leader>tc", function() coverage.summary() end,                      desc = "Coverage" },
        { "<leader>tf", function() neotest.run.run(vim.fn.expand('%')) end,     desc = "File" },
        { "<leader>tj", function() neotest.jump.next({ status = 'failed' }) end, desc = "Next Failed" },
        { "<leader>tk", function() neotest.jump.prev({ status = 'failed' }) end, desc = "Prev Failed" },
        { "<leader>tr", function() neotest.output.open() end,                   desc = "Results" },
        { "<leader>ts", function() neotest.summary.toggle() end,                desc = "Summary" },
        { "<leader>tt", function() neotest.run.run() end,                       desc = "Run Nearest" },
        -- NOTE: Will produce error unless executed inside a file containing tests
        -- To be able to execute this without having to go through a test file, the adapter option must be set.
        -- The adapter arg expects "adapter_name:root_dir" as adapter_id. Might want to check if a lua function
        -- can be used to figure this out based on e.g. file extension. Ex: python files would specify neotest-python.
        -- example: lua require('neotest').run.run({ suite = true, adapter = 'neotest-python:/home/og/projects/personal/nvim-demo/python' })
        { "<leader>tw", function() neotest.run.run({ suite = true }) end,       desc = "Workspace" },
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
  {
    "orjangj/neobuild",
    enabled = false, -- disable for now
    -- Keymaps for later
    --     b = {
    --       --b = { "<cmd>lua require('neobuild').build()<cr>", "Build" },
    --       --c = { "<cmd>lua require('neobuild').configure()<cr>", "Configure" },
    --       --d = { "<cmd>lua require('neobuild').clean()<cr>", "Clean" },
    --       --f = { "<cmd>lua require('neobuild').build(vim.fn.expand('%'))<cr>", "Build File" },
    --     },
    dev = vim.fn.isdirectory("~/projects/git/neobuild") and true or false,
    config = function()
      require("neobuild").setup({})
    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "akinsho/toggleterm.nvim" },
    },
    keys = function()
      local success, wk = pcall(require, "which-key")
      if success then
        wk.register({
          mode = { "n", "v" },
          ["<leader>b"] = { name = "Build" },
        })
      end

      return {
        { "<leader>bb", "<cmd>CMakeBuild<cr>",            desc = "CMake Build" },
        { "<leader>bc", "<cmd>CMakeClean<cr>",            desc = "CMake Clean" },
        { "<leader>bf", "<cmd>Telescope cmake_tools<cr>", desc = "CMake Project Files" },
        { "<leader>bt", "<cmd>CMakeRunTest<cr>",          desc = "Run CTest" },
        { "<leader>bs", "<cmd>CMakeSettings<cr>",         desc = "CMake Settings" },
      }
    end,
    config = function()
      require("cmake-tools").setup({
        cmake_regenerate_on_save = false,
        cmake_build_directory = "build/${variant:buildType}",
        cmake_executor = {
          name = "quickfix",
          opts = { show = "only_on_error", size = 30 },
        },
        cmake_runner = {
          name = "quickfix",
          opts = { show = "only_on_error", size = 30 },
        },
      })
    end,
  },
}
