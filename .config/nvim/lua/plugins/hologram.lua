return {
  "edluffy/hologram.nvim",
  config = function ()
    require("hologram").setup({
      --auto_display = true,  -- https://github.com/edluffy/hologram.nvim/pull/26
    })
  end
}
