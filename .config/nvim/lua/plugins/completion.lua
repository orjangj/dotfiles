return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end,
      },
      { "nvim-lua/plenary.nvim" },         -- for curl, log and async functions
      { "nvim-telescope/telescope.nvim" }, -- for help actions
    },
    opts = {
      -- See Configuration section for options
    },
    -- stylua: ignore
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>",        desc = "Toggle Chat" },
      { "<leader>al", "<cmd>CopilotChatReset<cr>",         desc = "Reset Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>",       desc = "Explain Code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>",         desc = "Generate Tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>",        desc = "Review Code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>",      desc = "Refactor Code" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "Better Naming" },
      { "<leader>af", "<cmd>CopilotChatFixError<cr>",      desc = "Fix Diagnostic" },
      { "<leader>am", "<cmd>CopilotChatModels<cr>",        desc = "Select Models" },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", commit = "a8912b88ce488f411177fc8aed358b04dc246d7b" }, -- later commits requires nvim 0.11+
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-cmdline" },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    config = function()
      local cmp = require("cmp")

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "nvim_lua" },
        }),
        formatting = {
          expandable_indicator = true,
          fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              path = "[Path]",
              spell = "[Spell]",
            })[entry.source.name]
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({
            TriggerOnly = "triggerOnly",
          }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
      })
    end,
  },
}
