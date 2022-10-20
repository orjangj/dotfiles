local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install plugins here
return packer.startup(function(use)
  -- Can be called like use({ ... }), but expects local plugin to be
  -- available in path "~/projects/git/"
  local local_use = function(plugin)
    assert(vim.fn.isdirectory(vim.fn.expand("~/projects/git/" .. plugin[1])) == 1)
    plugin[1] = vim.fn.expand("~/projects/git/" .. plugin[1])
    use(plugin)
  end

  -- Local plugins
  local_use({ "neotest-ctest" })

  use({ "wbthomason/packer.nvim" }) -- Allow packer to manage itself
  use({ "nvim-lua/plenary.nvim" }) -- Required by most plugins
  use({ "nvim-treesitter/nvim-treesitter" }) -- Required by most plugins

  -- Speed up loading time
  use({ "lewis6991/impatient.nvim" })

  -- Editing helpers
  use({ "windwp/nvim-autopairs" })
  use({
    "numToStr/Comment.nvim",
    requires = {
      { "JoosepAlviste/nvim-ts-context-commentstring" }
    }
  })
  use({ "lukas-reineke/indent-blankline.nvim" })

  -- Terminal integrations
  use({ "akinsho/toggleterm.nvim" })

  -- Keybindings and navigation helpers
  use({ "goolord/alpha-nvim" })
  use({
    "folke/which-key.nvim",
    requires = {
      { "moll/vim-bbye" },
    },
  })

  -- File explorer
  use({ "kyazdani42/nvim-tree.lua" })
  use({ "kyazdani42/nvim-web-devicons" })

  -- Project management
  use({ "ahmedkhalf/project.nvim" })

  -- Status line
  use({ "akinsho/bufferline.nvim" })
  use({ "nvim-lualine/lualine.nvim" })

  -- Comletion and snippets
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "saadparwaiz1/cmp_luasnip" },
    },
  })
  use({ "L3MON4D3/LuaSnip" })
  use({ "rafamadriz/friendly-snippets" })
  use({ "folke/neodev.nvim" })

  -- LSP and diagnostics
  use({ "folke/trouble.nvim" })
  use({
    "neovim/nvim-lspconfig",
    requires = {
      { "williamboman/nvim-lsp-installer" },
      { "jose-elias-alvarez/null-ls.nvim" },
    },
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "ghassan0/telescope-glyph.nvim" },
      { "smartpde/telescope-recent-files" },
    },
  })

  -- Git integration
  use({ "lewis6991/gitsigns.nvim" })

  -- Colorschemes
  use({ "shaunsingh/nord.nvim" })
  use({ "rmehri01/onenord.nvim" })
  use({ "norcalli/nvim-colorizer.lua" })

  -- Debugging and testing
  use({
    "mfussenegger/nvim-dap",
    requires = {
      { "mfussenegger/nvim-dap-python" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "jbyuki/one-small-step-for-vimkind" },
    },
  })
  use({
    "nvim-neotest/neotest",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "andythigpen/nvim-coverage" },
    },
  })

  -- Organizational tools
  use({
    "nvim-neorg/neorg",
    requires = {
      { "folke/zen-mode.nvim" },
      { "folke/twilight.nvim" },
    },
    run = ":Neorg sync-parsers",
  })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
