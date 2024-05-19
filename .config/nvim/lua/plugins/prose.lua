return {
  -- {{{ Neorg
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    "nvim-neorg/neorg",
    dependencies = {
      { "vhyrro/luarocks.nvim" },
      { "folke/zen-mode.nvim" },
      { "folke/twilight.nvim" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.keybinds"] = { -- Configure core.keybinds
            config = {
              default_keybinds = true,
              hook = function(keybinds)
                keybinds.map("norg", "n", "mp", "<cmd>Neorg presenter start<CR>")
              end,
            },
          },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
                cookbook = "~/projects/git/cookbook",
              },
              default_workspace = "notes",
            },
          },
        },
      })

      -- local hologram = require("hologram")
      -- local buffer = 0
      --
      -- vim.api.nvim_set_decoration_provider(vim.g.hologram_extmark_ns, {
      --   on_win = function(_, _, buf, top, bot)
      --     vim.schedule(function()
      --       hologram.buf_render_images(buf, top, bot)
      --     end)
      --   end,
      -- })
      --
      -- require("neorg.callbacks").on_event("core.neorgcmd.events.presenter.start", function(event, _)
      --   vim.api.nvim_set_hl(0, "@neorg.markup.verbatim", { link = "EndOfBuffer" })
      --   buffer = event.buffer
      --   hologram.buf_generate_images(event.buffer, 0, -1)
      -- end)
      --
      -- require("neorg.callbacks").on_event("core.neorgcmd.events.presenter.close", function(event, _)
      --   -- NOTE: event.buffer doesn't seem to match the buffer in presenter start event, so we'll use
      --   -- the stored buffer variable instead
      --   hologram.buf_delete_images(buffer, 0, -1)
      --   vim.api.nvim_set_hl(0, "@neorg.markup.verbatim", { link = "Comment" })
      -- end)
      --
      -- require("neorg.callbacks").on_event("core.keybinds.events.core.presenter.close", function(event, content)
      --   -- NOTE: event.buffer doesn't seem to match the buffer in presenter start event, so we'll use
      --   -- the stored buffer variable instead
      --   hologram.buf_delete_images(buffer, 0, -1)
      --   vim.api.nvim_set_hl(0, "@neorg.markup.verbatim", { link = "Comment" })
      -- end)
    end,
  },
  -- }}}
  -- {{{ Markdown
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- }}}
  -- {{{ Headlines
  {
    "lukas-reineke/headlines.nvim",
    config = function()
      require("headlines").setup({
        markdown = {
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
          },
          codeblock_highlight = "CodeBlock",
          dash_highlight = "Dash",
          quote_highlight = "Quote",
        },
      })
    end,
  },
  -- }}}
}
