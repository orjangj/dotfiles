return {
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "akinsho/toggleterm.nvim" },
    },
    keys = {
      { "<leader>bb", "<cmd>CMakeBuild<cr>",            desc = "CMake Build" },
      { "<leader>bc", "<cmd>CMakeClean<cr>",            desc = "CMake Clean" },
      { "<leader>bf", "<cmd>Telescope cmake_tools<cr>", desc = "CMake Project Files" }, -- TODO: load extension?
      { "<leader>bt", "<cmd>CMakeRunTest<cr>",          desc = "Run CTest" },
      { "<leader>bs", "<cmd>CMakeSettings<cr>",         desc = "CMake Settings" },
    },
    config = function()
      require("cmake-tools").setup({
        cmake_regenerate_on_save = false,
        cmake_build_directory = "build/${variant:buildType}",
        cmake_executor = {
          name = "quickfix",
          opts = { show = "only_on_error", size = 30 },
        },
        cmake_runner = {
          name = "quickfix",
          opts = { show = "only_on_error", size = 30 },
        },
      })
    end,
  },
}
