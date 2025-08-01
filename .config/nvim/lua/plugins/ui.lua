return {
  -- {{{ Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        [[                                                    ]],
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        [[                                                    ]],
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button(
          "f",
          "  Find file",
          ":Telescope find_files find_command=rg,--files,--hidden,--glob,!.git<CR>"
        ),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("c", "  Configuration", ":cd ~/.config/nvim <CR>:e init.lua <CR>"),
        dashboard.button("d", "  Dotfiles", ":cd ~/.config <CR>:Telescope find_files <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }

      dashboard.section.footer.val = "Slow is Smooth, Smooth is Fast"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.opts.noautocmd = true
      require("alpha").setup(dashboard.opts)
    end,
  },
  -- }}}
  -- {{{ Tab/Bufferline
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local options = {
        numbers = "none",
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = { icon = "▎", style = "icon" },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = false,
        diagnostics_update_in_insert = false,
        offsets = { { filetype = "NvimTree", text = "File Explorer", padding = 1, highlight = "NvimTreeNormal" } },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "slim",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
      }

      local highlights = {
        -- fg/bg color for tabline area
        fill = {
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of a buffer when not focused
        background = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of main close button (most right button)
        tab_close = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of close button for unfocused buffers
        close_button = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color for close button of current buffer when another window/tab is focused
        close_button_visible = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color for close button of current buffer when focused
        close_button_selected = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "TabLine" },
        },
        -- fg/bg color of current buffer when another window/tab is focused
        buffer_visible = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of current buffer
        buffer_selected = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "TabLine" },
        },
        -- fg/bg color of close button for unfocused (modified) buffer
        modified = {
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of close button for current (modified) buffer when another window/tab is focused
        modified_visible = {
          bg = { attribute = "bg", highlight = "TabLine" },
        },
        -- fg/bg color of close button for current (modified) buffer
        modified_selected = {
          bg = { attribute = "bg", highlight = "TabLine" },
        },
        -- fg/bg color of separator area between buffers
        separator = {
          fg = { attribute = "bg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of indicator area when not focused
        indicator_visible = {
          fg = { attribute = "bg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },
        -- fg/bg color of indicator area when focused
        indicator_selected = {
          bg = { attribute = "bg", highlight = "TabLine" },
        },
        trunc_marker = {
          bg = { attribute = "bg", highlight = "Normal" },
        },
      }

      require("bufferline").setup({ options = options, highlights = highlights })
    end,
  },
  -- }}}
  -- {{{ Statusline
  {
    -- TODO: Get inspired
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      local hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = { error = " ", warn = " " },
        colored = false,
        update_in_insert = false,
        always_visible = true,
      }

      local diff = {
        "diff",
        colored = false,
        symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
        cond = hide_in_width,
      }

      local mode = {
        "mode",
        fmt = function(str)
          return "-- " .. str .. " --"
        end,
      }

      local filetype = {
        "filetype",
        icons_enabled = false,
        icon = nil,
      }

      local branch = {
        "branch",
        icons_enabled = true,
        icon = "",
      }

      local location = {
        "location",
        padding = 0,
      }

      -- cool function for progress
      local progress = function()
        local current_line = vim.fn.line(".")
        local total_lines = vim.fn.line("$")
        local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
      end

      local spaces = function()
        return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { branch, diagnostics },
          lualine_b = { mode },
          lualine_c = {},
          -- lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_x = { diff, spaces, "encoding", filetype },
          lualine_y = { location },
          lualine_z = { progress },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  },
  -- }}}
  -- {{{ Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    opts = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
        vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
        vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
        vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
        vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
        -- END_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
      end

      return {
        on_attach = on_attach,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          adaptive_size = true,
        },
        renderer = {
          root_folder_modifier = ":t",
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "",
                staged = "S",
                unmerged = "",
                renamed = "➜",
                untracked = "U",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
  -- }}}
  -- {{{ Notifications
  {
    "rcarriga/nvim-notify",
    tag = "v3.14.1",
    event = "VeryLazy",
    config = function()
      vim.notify = require("notify")
    end,
  },
  -- }}}
  -- {{{ Zen
  {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle ZenMode" },
    },
    init = function() end,
    opts = {
      window = {
        -- TODO: Maybe move neorg stuff to presenter keybinding?
        width = function()
          -- NOTE: doesn't account for window resize
          local w = vim.api.nvim_win_get_width(0)
          if vim.bo.filetype == "norg" then
            w = w * 0.7
          else
            w = w * 0.95
          end
          return w
        end,
        height = function()
          -- NOTE: doesn't account for window resize
          local h = vim.api.nvim_win_get_height(0)
          if vim.bo.filetype == "norg" then
            h = h * 0.85
          end
          return h
        end,
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      -- TODO: Maybe use zen-mode LUA api as part of neorg keymaps to perform this behavior?
      on_open = function(win)
        -- TODO: Neorg presenter mode integration
        -- 1) Increase font size when in neorg presenter mode
        -- 2) vim.opt.laststatus = 0
        vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })
      end,
      on_close = function()
        -- TODO: Neorg presneter mode integration
        -- 1) Reset font size when exiting neorg presenter mode
        -- 2) vim.opt.laststatus = 3
      end,
    },
  },
  -- }}}
  -- {{{ Which-key
  {
    "folke/which-key.nvim",
    event = "VimEnter", -- TODO: This wasn't necessary before, but which-key doesn't seem to be loaded fast enough with keys
    keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
    dependencies = {
      "moll/vim-bbye",
      "nvim-web-devicons",
    },
    opts = {
      icons = { group = "" },
      win = { border = "rounded" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      local keymaps = {
        mode = { "n", "v" },
        -- Single-keys
        { "<leader>c", "<cmd>Bdelete!<cr>", desc = "Close Buffer" },
        { "<leader>h", "<cmd>nohlsearch<cr>", desc = "No Highlight" }, -- Make it Toggle hightlight
        { "<leader>p", "<cmd>Lazy<cr>", desc = "Plugin" },
        { "<leader>q", "<cmd>q!<cr>", desc = "Quit" },
        { "<leader>w", "<cmd>w!<cr>", desc = "Save Buffer" },
        -- Groups
        { "<leader>a", group = "Annotate" },
        { "<leader>b", group = "Build" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>j", group = "Harpoon" },
        { "<leader>t", group = "Test" },
        { "<leader>l", group = "LSP/Diagnostics" },
      }
      wk.add(keymaps)
    end,
    -- config = function()
    --
    --   local mappings = {
    --   }
    --
    --   require("which-key").setup(setup)
    --   require("which-key").register(mappings, opts)
    -- end,
  },
  -- }}}
}
