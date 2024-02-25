return {
  {
    "windwp/nvim-autopairs",
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
    "numToStr/Comment.nvim",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
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
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "andythigpen/nvim-coverage" },
      { "orjangj/neotest-ctest" },
    },
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
      })
    end,
  },
  {
    "orjangj/neobuild",
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
    config = function()
      require("cmake-tools").setup({
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
