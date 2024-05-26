-- TODO: look into https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- TODO: Auto update LSP servers?
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim" },
      { "folke/trouble.nvim" },
      {
        "j-hui/fidget.nvim",
        tag = "v1.4.5",
        opts = {
          integration = {
            ["nvim-tree"] = {
              enable = false,
            },
          },
        },
      },
    },
    config = function()
      require("neodev").setup()

      local servers = {
        ansiblels = {},
        clangd = {
          cmd = {
            "clangd",
            -- FIX: Doesn't seem to work (look into overriding capabilities)
            --      Seem to be fixed in nvim v0.10.0 though? See https://github.com/neovim/neovim/commit/15641f38cf4b489a7c83e2c3aa6efc4c63009f00
            -- "--offset-encoding=utf-16",
            "--background-index",
            "--clang-tidy",
            "--completion-style=bundled",
            "--cross-file-rename",
            "--header-insertion=iwyu",
          },
        },
        cmake = {},
        -- cpptools = {}, -- TODO: Check it out
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

      local ensure_installed = vim.tbl_keys(servers)
      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      for server, settings in pairs(servers) do
        require("lspconfig")[server].setup({
          capabilities = capabilities,
          settings = settings,
        })
      end

      -- note: diagnostics are not exclusive to lsp servers
      -- so these can be global keybindings
      vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
      vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
      vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          -- these will be buffer-local keybindings
          -- because they only work if you have an active language server

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
          vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
          vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
          vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
          vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
          vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Configure ui/window borders for lsp/diagnostics
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
      vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })

      require("trouble").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = { "BufReadPre", "BufNewFile" },
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
          diagnostics.cppcheck, -- TODO: only enable warnings, and update on save or insert leave
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
