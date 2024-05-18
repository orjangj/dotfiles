return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "jose-elias-alvarez/null-ls.nvim" },
    { "folke/neodev.nvim" },
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
      event = "LspAttach",
    },
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

    -- null-ls setup
    local null_ls = require("null-ls")
    local null_opts = lsp.build_options("null-ls", {})
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    null_ls.setup({
      on_attach = function(client, bufnr)
        null_opts.on_attach(client, bufnr)
      end,
      debug = false,
      sources = {
        code_actions.gitsigns,
        diagnostics.cppcheck, -- TODO only enable warnings, and update on save or insert leave
        diagnostics.flake8.with({ extra_args = { "--max-line-length", "120" } }),
        diagnostics.cmake_lint,
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
        formatting.cmake_format.with({ extra_args = {"--line-width", "120" } }),
      },
    })

    -- nvim-lint setup
    --require("lint").linters_by_ft = {
    --  c = { "clangtidy" },  -- flawfinder
    --}
    --vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    --  callback = function()
    --    require("lint").try_lint()
    --  end,
    --})

    require("fidget").setup()
    require("trouble").setup()
  end,
}
