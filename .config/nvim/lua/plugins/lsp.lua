return {
  { -- TODO: Remove lsp-zero
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim" },
      { "folke/trouble.nvim" },
      { "mfussenegger/nvim-lint" },
    },
    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require("neodev").setup()

      require("mason.settings").set({
        ui = {
          border = "rounded",
        },
      })

      local lsp = require("lsp-zero").preset({
        name = "minimal",
        set_lsp_keymaps = true,
        manage_nvim_cmp = false,
        suggest_lsp_servers = false,
        sign_icons = {
          error = "",
          warn = "",
          hint = "ﴞ",
          info = "",
        },
      })

      local servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=bundled",
            "--cross-file-rename",
            "--header-insertion=iwyu",
          },
        },
        cmake = {},
        ansiblels = {},
        lua_ls = {
          Lua = {
            diagnostics = {
              globals = { "vim", "describe", "it" },
            },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
          },
        },
      }

      lsp.ensure_installed(vim.tbl_keys(servers))

      for server, settings in pairs(servers) do
        lsp.configure(server, {
          --on_attach = require("plugins.lsp.handlers").on_attach,
          --capabilities = require("plugins.lsp.handlers").capabilities,
          settings = settings,
        })
      end

      lsp.nvim_workspace()
      lsp.setup()

      vim.diagnostic.config({ virtual_text = true })
      require("lspconfig.ui.windows").default_options.border = "rounded" -- TODO other ways to do this?

      -- nvim-lint setup
      --require("lint").linters_by_ft = {
      --  c = { "clangtidy" },  -- flawfinder
      --}
      --vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      --  callback = function()
      --    require("lint").try_lint()
      --  end,
      --})

      require("trouble").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      -- null-ls setup
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      null_ls.setup({
        debug = false,
        sources = {
          code_actions.gitsigns,
          diagnostics.cppcheck, -- TODO only enable warnings, and update on save or insert leave
          diagnostics.cmake_lint,
          -- TODO: consider using ruff for python linting (requires none-ls-extras.nvim)
          formatting.prettier.with({
            filetypes = {
              "json",
              "yaml",
              "markdown",
              "md",
              "txt",
            },
          }),
          formatting.black.with({ extra_args = { "--fast", "--line-length", "100" } }),
          formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
          formatting.cmake_format.with({ extra_args = { "--line-width", "120" } }),
        },
      })
    end,
  },
}
