return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "nvim-neotest/nvim-nio" },  -- nvim-dap-ui dependency
    { "theHamsta/nvim-dap-virtual-text" },
  },
  cmd = { "DapInstall", "DapUninstall" },
  keys = function()
    local dap = require("dap")
    local dapui = require("dapui")
    -- stylua: ignore
    return {
      { "<leader>dR", function() dap.run_to_cursor() end,                                               desc = "Run to Cursor" },
      { "<leader>dE", function() dapui.eval(vim.fn.input("[Expression] > ")) end,                       desc = "Evaluate Input" },
      { "<leader>de", function() dapui.eval() end,                                                      mode = { "n", "v" },            desc = "Evaluate" },
      { "<leader>dC", function() dap.set_breakpoint(vim.fn.input("[Condition] > ")) end,                desc = "Conditional Breakpoint" },
      { "<leader>dL", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, silent = true,                  desc = "Set Breakpoint" },
      { "<leader>dU", function() dapui.toggle() end,                                                    desc = "Toggle UI" },
      { "<leader>dp", function() dap.pause.toggle() end,                                                desc = "Pause" },
      { "<leader>dr", function() dap.repl.toggle() end,                                                 desc = "Toggle REPL" },
      { "<leader>dt", function() dap.toggle_breakpoint() end,                                           desc = "Toggle Breakpoint" },
      { "<leader>dB", function() dap.step_back() end,                                                   desc = "Step Back" },
      { "<leader>dc", function() dap.continue() end,                                                    desc = "Continue" },
      { "<leader>ds", function() dap.continue() end,                                                    desc = "Start" },
      { "<leader>dd", function() dap.disconnect() end,                                                  desc = "Disconnect" },
      { "<leader>dg", function() dap.session() end,                                                     desc = "Get Session" },
      { "<leader>dh", function() dap.ui.widgets.hover() end,                                            desc = "Hover Variables" },
      { "<leader>dS", function() dap.ui.widgets.scopes() end,                                           desc = "Scopes" },
      { "<leader>di", function() dap.step_into() end,                                                   desc = "Step Into" },
      { "<leader>do", function() dap.step_over() end,                                                   desc = "Step Over" },
      { "<leader>du", function() dap.step_out() end,                                                    desc = "Step Out" },
      { "<leader>dq", function() dap.close() end,                                                       desc = "Quit" },
      { "<leader>dx", function() dap.terminate() end,                                                   desc = "Terminate" },
      { "<leader>dO", function() dap.repl.open() end,                                                   silent = true,                  desc = "Repl Open" },
      { "<leader>dl", function() dap.run_last() end,                                                    silent = true,                  desc = "Run Last" },
    }
  end,
  config = function()
    local dap = require("dap")

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

    require("nvim-dap-virtual-text").setup()
  end,
}
