return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    -- Extensions
    { "nvim-telescope/telescope-frecency.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-media-files.nvim" },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope-symbols.nvim" },
  },
  cmd = "Telescope",
  -- stylua: ignore
  keys = {
    { "<leader>fc", "<cmd>Telescope commands<cr>",                                   desc = "Commands" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>",                                 desc = "Files" },
    { "<leader>fr", "<cmd>Telescope frecency workspace=CWD<cr>",                     desc = "Recent Files" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                  desc = "Help Tags" },
    { "<leader>fm", "<cmd>Telescope man_pages<cr>",                                  desc = "Man Pages" },
    { "<leader>fn", "<cmd>Telescope notify<cr>",                                     desc = "Notification history" },
    { "<leader>fp", "<cmd>Telescope project display_type=full<cr>",                  desc = "Projects" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>",                                  desc = "Search" },
    { "<leader>fS", "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>",        desc = "Search (buffer)" },
    { "<leader>fz", "<cmd>Telescope symbols<cr>",                                    desc = "Symbols" },
    { "<leader>fZ", "<cmd>Telescope spell_suggest<cr>",                              desc = "Spelling Suggestions" },
  },
  opts = function()
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        -- TODO: git_status seem to show more than what is source controlled in dotfiles
        git_worktrees = {
          {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/dotfiles",
          },
        },
        -- See default mappings @ https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
        mappings = {
          i = {
            ["<C-n>"] = require("telescope.actions").cycle_history_next,
            ["<C-p>"] = require("telescope.actions").cycle_history_prev,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
      pickers = {
        find_files = {
          -- Make find_files work like git_files, but also show hidden and untracked files
          find_command = { "rg", "--files", "--hidden", "--glob", "!{.git,node_modules,venv,.venv}/*" },
        },
        live_grep = { theme = "ivy" },
      },
      extensions = {
        project = {
          base_dirs = {
            { path = vim.env.HOME .. "/projects/git", max_depth = 2 },
          },
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          on_project_selected = function(prompt_bufnr)
            require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
          end,
        },
        recent_files = {
          only_cwd = true,
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("frecency")
    telescope.load_extension("fzf")
    telescope.load_extension("media_files")
    telescope.load_extension("project")
  end,
}
