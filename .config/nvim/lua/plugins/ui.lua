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
        dashboard.button("e", "  Open Explorer", ":Telescope file_browser<cr>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("p", "  Find project", ":Telescope project <CR>"),
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
  -- See telescope-file-browser in telescope.lua config
  -- }}}
  -- {{{ Notifications
  {
    "rcarriga/nvim-notify",
    tag = "v3.14.1",
    event = "VimEnter",
    config = function()
      vim.notify = require("notify")
    end,
  },
  -- }}}
  -- {{{ Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
    dependencies = {
      "moll/vim-bbye", -- See Bdelete! command
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
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Build" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>t", group = "Test" },
        { "<leader>l", group = "LSP" },
      }
      wk.add(keymaps)
    end,
  },
  -- }}}
}
