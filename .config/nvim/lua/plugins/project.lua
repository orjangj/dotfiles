return {
  -- TODO: Use telescope-project.nvim instead?
  -- Until this is fixed at least: https://github.com/ahmedkhalf/project.nvim/issues/123 
  -- And something like this is added: https://github.com/ahmedkhalf/project.nvim/issues/73
  "ahmedkhalf/project.nvim",
  enabled = false,
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
