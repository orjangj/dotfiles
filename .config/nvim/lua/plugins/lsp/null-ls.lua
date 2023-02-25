local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    code_actions.gitsigns,
    diagnostics.flake8.with({ extra_args = {"--max-line-length", "120" } }),
    formatting.prettier.with({
      filetypes = {
        "json",
        "yaml",
        "markdown",
        "md",
        "txt",
      },
    }),
    formatting.black.with({ extra_args = { "--fast", "--line-length", "120" } }),
    formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
  },
})
