return {
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
      ["1"] = { "<cmd>ToggleTerm direction=float<cr>", "Terminal (float)" },
      ["2"] = { "<cmd>ToggleTerm size=90 direction=vertical<cr>", "Terminal (vertical)" },
      ["3"] = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
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
        b = { "<cmd>lua require('neobuild').build()<cr>", "Build"},
        c = { "<cmd>lua require('neobuild').configure()<cr>", "Configure"},
        d = { "<cmd>lua require('neobuild').clean()<cr>", "Clean"},
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
}
