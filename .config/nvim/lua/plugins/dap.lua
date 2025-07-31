return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "nvim-neotest/nvim-nio" }, -- nvim-dap-ui dependency
    { "theHamsta/nvim-dap-virtual-text" },
  },
  cmd = { "DapInstall", "DapUninstall" },
  keys = function()
    local dap = require("dap")
    local dapui = require("dapui")
    -- stylua: ignore
    return {
      -- Session control
      { "<leader>dd", function() dap.continue() end,          desc = "Start/Continue" },
      { "<leader>dq", function() dap.terminate() end,         desc = "Quit" },
      { "<leader>dp", function() dap.pause() end,             desc = "Pause" },
      -- Stepping
      { "<leader>dk", function() dap.step_back() end,         desc = "Step Back" },
      { "<leader>dj", function() dap.step_into() end,         desc = "Step Into" },
      { "<leader>dJ", function() dap.step_over() end,         desc = "Step Over" },
      { "<leader>dl", function() dap.step_out() end,          desc = "Step Out" },
      -- Breakpoint
      { "<leader>dr", function() dap.run_to_cursor() end,     desc = "Run to Cursor" },
      { "<leader>db", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() dap.clear_breakpoints() end, desc = "Clear Breakpoints" },
      -- Inspection
      { "<leader>de", function() dapui.eval() end,            mode = { "n", "v" },       desc = "Evaluate" },
    }
  end,
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
