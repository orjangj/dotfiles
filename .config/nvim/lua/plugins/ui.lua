return {
  -- {{{ Dashboard
  {
    "goolord/alpha-nvim",
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
        dashboard.button(
          "f",
          "  Find file",
          ":Telescope find_files find_command=rg,--files,--hidden,--glob,!.git<CR>"
        ),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Configuration", ":cd ~/.config/nvim <CR>:e init.lua <CR>"),
        dashboard.button("d", "  Dotfiles", ":cd ~/.config <CR>:Telescope find_files <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }

      local function footer()
        return "OG"
      end

      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.opts.opts.noautocmd = true
      require("alpha").setup(dashboard.opts)
    end,
  },
  -- }}}
  -- {{{ Tab/Bufferline
  {
    "akinsho/bufferline.nvim",
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
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
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
      }

      require("bufferline").setup({ options = options, highlights = highlights })
    end,
  },
  -- }}}
  -- {{{ Statusline
  {
    "nvim-lualine/lualine.nvim",
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
    config = function()
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

      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
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
        on_attach = on_attach,
      })
    end,
  },
  -- }}}
  -- {{{ Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },
  -- }}}
  -- {{{ Zen
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 1,
          -- height and width can be:
          -- * an absolute number of cells when > 1
          -- * a percentage of the width / height of the editor when <= 1
          -- * a function that returns the width or the height
          width = 0.70, -- width of the Zen window in number of characters
          height = 0.85, -- height of the Zen window in number of lines
          -- by default, no options are changed for the Zen window
          -- uncomment any of the options below, or add other vim.wo options you want to apply
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
        plugins = {
          -- disable some global vim options (vim.o...)
          -- comment the lines to not apply the options
          options = {
            enabled = true,
            ruler = false, -- disables the ruler text in the cmd line area
            showcmd = false, -- disables the command in the last line of the screen
          },
          twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
          gitsigns = { enabled = false }, -- disables git signs
          tmux = { enabled = false }, -- disables the tmux statusline
          kitty = {
            enabled = true,
            font = "+3",
          },
        },
        -- callback where you can add custom code when the Zen window opens
        on_open = function(win) end,
        -- callback where you can add custom code when the Zen window closes
        on_close = function() end,
      })
    end,
  },
  -- }}}
  -- {{{ Which-key
  {
    "folke/which-key.nvim",
    dependencies = {
      "moll/vim-bbye",
    },
    config = function()
      local setup = {
        icons = { group = "" },
        window = { border = "rounded" },
        ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
      }

      local opts = {
        prefix = "<leader>",
        nowait = true, -- use `nowait` when creating keymaps
      }

      local mappings = {
        ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
        ["c"] = { "<cmd>Bdelete!<cr>", "Close Buffer" },
        ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        ["h"] = { "<cmd>nohlsearch<cr>", "No Highlight" },
        ["p"] = { "<cmd>Lazy<cr>", "Plugin" },
        ["q"] = { "<cmd>q!<cr>", "Quit" },
        ["w"] = { "<cmd>w!<cr>", "Save Buffer" },
        ["z"] = { "<cmd>ZenMode<cr>", "Zen Mode" },
        b = {
          name = "Build",
          b = { "<cmd>lua require('neobuild').build()<cr>", "Build" },
          c = { "<cmd>lua require('neobuild').configure()<cr>", "Configure" },
          d = { "<cmd>lua require('neobuild').clean()<cr>", "Clean" },
          f = { "<cmd>lua require('neobuild').build(vim.fn.expand('%'))<cr>", "Build File" },
        },
        g = {
          name = "Git",
          b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
          c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
          d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
          g = { "<cmd>LazyGit<cr>", "LazyGit" },
          j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
          k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
          l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame Line" },
          L = { "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>", "Blame Toggle" },
          o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
          p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
          r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
          R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
          s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
          S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage buffer" },
          u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
          U = { "<cmd>lua require 'gitsigns'.reset_buffer_index()<cr>", "Undo Stage Buffer" },
        },
        f = {
          name = "Find",
          b = {
            "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
            "Buffers",
          },
          c = { "<cmd>Telescope commands<cr>", "Commands" },
          f = { "<cmd>Telescope find_files<cr>", "Files" },
          F = { "<cmd>lua require('telescope').extensions.recent_files.pick()<cr>", "Recent Files" },
          g = { "<cmd>Telescope glyph<cr>", "Glyphs" },
          h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
          i = { "<cmd>Telescope media_files<cr>", "Media Files" },
          m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
          n = { "<cmd>Telescope notify<cr>", "Notify history" },
          p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
          s = { "<cmd>Telescope live_grep<cr>", "Workspace Search" },
          S = { "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>", "Buffer Search" },
          t = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
          z = { "<cmd>Telescope symbols<cr>", "Symbols" },
        },
        l = {
          name = "LSP/Diagnostics",
          a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
          A = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
          d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer Diagnostics" },
          D = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
          f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format Buffer" },
          i = { "<cmd>LspInfo<cr>", "List LSP Clients" },
          I = { "<cmd>Mason<cr>", "LSP Installer" },
          j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
          k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
          r = { "<cmd>Telescope lsp_references<cr>", "References" },
          R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
          s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
          S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
          t = { "<cmd>TroubleToggle<cr>", "Trouble Diagnostics" },
          z = { "<cmd>Telescope spell_suggest<cr>", "Spelling Suggestions" },
        },
        --      n = {
        --        name = "Neorg",
        --        -- n -- Open Neorg index file
        --        p = { "<cmd>Neorg presenter start<cr>", "Start Presentation"},
        --      },
        t = {
          name = "Test",
          -- TODO: Is there a way to specify test suite (namespace)?
          a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
          d = { "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<cr>", "Debug" },
          -- NOTE: Currently relies on either (1) manually executing CoverageLoad, or execute neotest on entire workspace.
          -- Not all adapters (i.e. pytest) makes it easy to isolate coverage report without knowing what modules are tested.
          -- Maybe there's a more elegant solution here, but this seems to work quite well.
          c = { "<cmd>lua require('coverage').summary()<cr>", "Coverage Summary" },
          f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
          j = { "<cmd>lua require('neotest').jump.next({ status = 'failed' })<cr>", "Next Failed Test" },
          k = { "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<cr>", "Prev Failed Test" },
          r = { "<cmd>lua require('neotest').output.open()<cr>", "Results" },
          s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
          t = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
          -- NOTE: Will produce error unless executed inside a file containing tests
          -- To be able to execute this without having to go through a test file, the adapter option must be set.
          -- The adapter arg expects "adapter_name:root_dir" as adapter_id. Might want to check if a lua function
          -- can be used to figure this out based on e.g. file extension. Ex: python files would specify neotest-python.
          -- example: lua require('neotest').run.run({ suite = true, adapter = 'neotest-python:/home/og/projects/personal/nvim-demo/python' })
          w = {
            "<cmd>lua require('neotest').run.run({ suite = true })<cr><cmd>lua require('coverage').load(true)<cr>",
            "Workspace",
          },
        },
      }

      require("which-key").setup(setup)
      require("which-key").register(mappings, opts)
    end,
  },
  -- }}}
}
