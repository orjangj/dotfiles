return {
  { "nvim-lua/plenary.nvim" }, -- Required by most plugins
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, -- Required by most plugins
  { "nvim-treesitter/playground" },

  -- Speed up loading time
  { "lewis6991/impatient.nvim" },

  -- Editing helpers
  { "gpanders/editorconfig.nvim" }, -- TODO: remove when nvim 0.9 is released (builtin)
  { "windwp/nvim-autopairs" },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring" },
    }
  },
  { "lukas-reineke/indent-blankline.nvim" },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  { "lukas-reineke/headlines.nvim" },

  -- Terminal integrations
  { "akinsho/toggleterm.nvim" },
  { "shaunsingh/nord.nvim" },

  -- Keybindings and navigation helpers
  { "goolord/alpha-nvim" },
  {
    "folke/which-key.nvim",
    dependencies = {
      { "moll/vim-bbye" },
    },
  },

  -- File explorer
  { "kyazdani42/nvim-tree.lua" },
  { "kyazdani42/nvim-web-devicons" },

  -- Project management
  { "ahmedkhalf/project.nvim" },

  -- Status line
  { "akinsho/bufferline.nvim" },
  { "nvim-lualine/lualine.nvim" },

  -- Comletion and snippets
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "saadparwaiz1/cmp_luasnip" },
    },
  },
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- LSP and diagnostics
  { "folke/trouble.nvim" },
  -- NOTE: the order of plugin install matters for mason
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jose-elias-alvarez/null-ls.nvim" },
      { "folke/neodev.nvim" },
      { "j-hui/fidget.nvim" },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "ghassan0/telescope-glyph.nvim" },
      { "smartpde/telescope-recent-files" },
    },
  },

  -- Git integration
  { "lewis6991/gitsigns.nvim" },

  -- Colorschemes
  { "orjangj/polar.nvim" },
  { "norcalli/nvim-colorizer.lua" },

  -- Debugging and testing
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "mfussenegger/nvim-dap-python" },
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "nvim-telescope/telescope-dap.nvim" },
      { "jbyuki/one-small-step-for-vimkind" },
    },
  },
  { "orjangj/neotest-ctest" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "antoinemadec/FixCursorHold.nvim" },
      { "nvim-neotest/neotest-python" },
      { "nvim-neotest/neotest-plenary" },
      { "andythigpen/nvim-coverage" },
    },
  },

  -- Organizational tools
  {
    "nvim-neorg/neorg",
    dependencies = {
      { "folke/zen-mode.nvim" },
      { "folke/twilight.nvim" },
    },
    build = ":Neorg sync-parsers",
  },
}
