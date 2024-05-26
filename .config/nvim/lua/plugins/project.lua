return {
  -- TODO: Use telescope-project.nvim instead?
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ">git" },
    })

    local tele_status_ok, telescope = pcall(require, "telescope")
    if not tele_status_ok then
      return
    end

    telescope.load_extension("projects")
  end,
}
