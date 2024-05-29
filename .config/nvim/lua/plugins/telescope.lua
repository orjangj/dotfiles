return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "ghassan0/telescope-glyph.nvim" },
    { "smartpde/telescope-recent-files" },
    { "nvim-telescope/telescope-media-files.nvim" },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
    --   "ahmedkhalf/project.nvim",
    --   opts = {
    --     detection_methods = { "pattern" },
    --     patterns = { ">git" },
    --   },
    --   config = function(_, opts)
    --     require("project_nvim").setup(opts)
    --   end,
    -- }
  },
  cmd = "Telescope",
  keys = function()
    local telescope = require("telescope")
    local extensions = telescope.extensions
    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")

    -- stylua: ignore
    return {
      { "<leader>fb", function() builtin.buffers(themes.get_dropdown({ previewer = false })) end, desc = "Buffers" },
      { "<leader>fc", function() builtin.commands() end,                                          desc = "Commands" },
      { "<leader>ff", function() builtin.find_files() end,                                        desc = "Files" },
      -- TODO: Pick recent files starting from cwd only?
      { "<leader>fF", function() extensions.recent_files.pick() end,                              desc = "Recent Files" },
      { "<leader>fg", "<cmd>Telescope glyph<cr>",                                                 desc = "Glyphs" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                             desc = "Help Tags" },
      { "<leader>fi", "<cmd>Telescope media_files<cr>",                                           desc = "Media Files" },
      { "<leader>fm", "<cmd>Telescope man_pages<cr>",                                             desc = "Man Pages" },
      { "<leader>fn", "<cmd>Telescope notify<cr>",                                                desc = "Notification history" },
      { "<leader>fp", function() extensions.project.project({ display_type = "full" }) end,       desc = "Projects" },
      -- { "<leader>fp", function () telescope.extensions.project.project({ display_type = "full" }) end, desc = "Projects" },
      -- { "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
      { "<leader>fs", "<cmd>Telescope live_grep<cr>",                                             desc = "Workspace Search" },
      { "<leader>fS", "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>",                   desc = "Buffer Search" },
      { "<leader>fz", "<cmd>Telescope symbols<cr>",                                               desc = "Symbols" },
      { "<leader>fZ", "<cmd>Telescope spell_suggest<cr>",                                         desc = "Spelling Suggestions" },
    }
  end,
  opts = function()
    local actions = require("telescope.actions")
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
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        find_files = {
          -- Make find_files work like git_files, but also show hidden and untracked files
          find_command = { "rg", "--files", "--hidden", "--glob", "!{.git,node_modules,venv,.venv}/*" },
        },
        live_grep = {
          theme = "ivy",
        },
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
            -- TODO: Close all currently open buffers
            --       Hmmm... maybe I need a session manager instead?
            --       A project + session manager would be great, but I also like the idea of integrating harpoon (with git integration)
            require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)

            -- TODO: This doesn't seem to work with harpoon2
            --       The list of harpoon files shows as empty even though the data store is not
            local has_harpoon, harpoon = pcall(require, "harpoon")
            if has_harpoon then
              harpoon:list():select(1)
              harpoon:list():select(2)
              harpoon:list():select(3)
              harpoon:list():select(4)
            end
          end,
        },
        recent_files = {
          only_cwd = true,
        },
        media_files = {
          find_cmd = "rg",
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("glyph")
    telescope.load_extension("recent_files")
    telescope.load_extension("media_files")
    telescope.load_extension("project")
  end,
}
