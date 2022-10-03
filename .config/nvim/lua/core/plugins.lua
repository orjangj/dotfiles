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
  use({ "wbthomason/packer.nvim" }) -- Allow packer to manage itself
  use({ "nvim-lua/plenary.nvim" }) -- Required by many plugins
  use({ "nvim-treesitter/nvim-treesitter" })

  use({ "windwp/nvim-autopairs" })
  use({ "numToStr/Comment.nvim" })
  use({ "JoosepAlviste/nvim-ts-context-commentstring" })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "kyazdani42/nvim-tree.lua" })
  use({ "akinsho/bufferline.nvim" })
  use({ "akinsho/toggleterm.nvim" })
  use({ "moll/vim-bbye" })
  use({ "nvim-lualine/lualine.nvim" })
  use({ "ahmedkhalf/project.nvim" })
  use({ "lewis6991/impatient.nvim" })
  use({ "lukas-reineke/indent-blankline.nvim" })
  use({ "goolord/alpha-nvim" })
  use({ "folke/which-key.nvim" })
  use({ "folke/trouble.nvim" })
  use({ "shaunsingh/nord.nvim" })

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
  use({ "neovim/nvim-lspconfig" })
  use({ "williamboman/nvim-lsp-installer" })
  use({ "jose-elias-alvarez/null-ls.nvim" })

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "ghassan0/telescope-glyph.nvim" },
      { "smartpde/telescope-recent-files" },
    },
  })

  use({ "lewis6991/gitsigns.nvim" })
  use({ "norcalli/nvim-colorizer.lua" })

  use({
    "nvim-neotest/neotest",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/neotest-vim-test" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "vim-test/vim-test" },
      { "mfussenegger/nvim-dap" },
    },
  })

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
