return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      manual_mode = true, -- Use :AddProject to manually add a project
    })

    local tele_status_ok, telescope = pcall(require, "telescope")
    if not tele_status_ok then
      return
    end

    telescope.load_extension("projects")
  end,
}
