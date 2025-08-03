return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "nvim-neotest/nvim-nio" }, -- nvim-dap-ui dependency
    { "theHamsta/nvim-dap-virtual-text" },
  },
  -- stylua: ignore
  keys = {
    { "<leader>dd", function() require('dap').continue() end,          desc = "Start/Continue" },
    { "<leader>dq", function() require('dap').terminate() end,         desc = "Quit" },
    { "<leader>dp", function() require('dap').pause() end,             desc = "Pause" },
    { "<leader>dk", function() require('dap').step_back() end,         desc = "Step Back" },
    { "<leader>dj", function() require('dap').step_into() end,         desc = "Step Into" },
    { "<leader>dJ", function() require('dap').step_over() end,         desc = "Step Over" },
    { "<leader>dl", function() require('dap').step_out() end,          desc = "Step Out" },
    { "<leader>dr", function() require('dap').run_to_cursor() end,     desc = "Run to Cursor" },
    { "<leader>db", function() require('dap').toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dB", function() require('dap').clear_breakpoints() end, desc = "Clear Breakpoints" },
    { "<leader>de", function() require('dapui').eval() end,            mode = { "n", "v" },       desc = "Evaluate" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- NOTE: Requires codelldb v1.11.0 or newer
    dap.adapters.codelldb = {
      type = "executable",
      command = "codelldb",
    }

    dap.configurations.c = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }

    dap.configurations.cpp = dap.configurations.c

    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    require("nvim-dap-virtual-text").setup({})
  end,
}
