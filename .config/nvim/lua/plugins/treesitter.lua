local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed =  {
    "bash",
    "c",
    "cmake",
    "cpp",
    "dockerfile",
    "help",
    "json",
    "lua",
    "make",
    "markdown",
    "norg",
    "python",
    "query",
    "rasi",
    "regex",
    "rst",
    "rust",
    "toml",
    "vim",
    "yaml",
  },
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = { enable = true },
	autopairs = { enable = true },
	indent = { enable = true, disable = { "python" } },
})
