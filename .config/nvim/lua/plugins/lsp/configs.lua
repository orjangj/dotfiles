local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local servers = {
  clangd = {},
  cmake = {},
  sumneko_lua = {
    Lua = {
		  diagnostics = {
		  	globals = { "vim", "describe", "it" },
		  },
      telemetry = { enable = false },
		  workspace = { checkThirdParty = false },
	  },
  },
}
-- Setup neovim lua configuration
require("neodev").setup()

-- Setup mason so it can manage external tooling
require("mason").setup()

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server)
    require("lspconfig")[server].setup({
      on_attach = require("plugins.lsp.handlers").on_attach,
      capabilities = require("plugins.lsp.handlers").capabilities,
      settings = servers[server],
    })
  end,
})

-- Setup fidget to show lsp server progress report
require("fidget").setup()
