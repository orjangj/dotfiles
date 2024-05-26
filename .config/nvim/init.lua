-- Enable the new |lua-loader| (nvim version > 0.9) that byte-compiles and caches lua files.
vim.loader.enable()

require("core.options")
require("core.keymaps")
require("core.autocommands")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end


vim.opt.runtimepath:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- TODO: Look into the config folder integration with lazy.
--       Currently, I'm using core as folder name.

return lazy.setup("plugins", {
  ui = {
    border = "rounded",
  },
  dev = {
    path = "~/projects/git",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        -- Vim plugin for editing compressed files.
        "gzip",
        -- tarPlugin.vim -- a Vim plugin for browsing tarfiles
        "tarPlugin",
        -- Vim plugin for converting a syntax highlighted file to HTML.
        "tohtml",
        -- zipPlugin.vim: Handles browsing zipfiles
        "zipPlugin",
        -- netrwPlugin.vim: Handles file transfer and remote directory listing across a network
        -- support of plugins written in other languages
        "netrwPlugin",
        "rplugin",
        -- Vim plugin for downloading spell files
        -- "spellfile",
        -- matchit.vim: (global plugin) Extended "%" matching
        -- "matchit",
        -- Vim plugin for showing matching parens
        -- "matchparen",
        -- "tutor",
        -- "man",
        -- "shada",
        -- "health",
        -- "editorconfig",
        -- "nvim",
      },
    },
  },
})
