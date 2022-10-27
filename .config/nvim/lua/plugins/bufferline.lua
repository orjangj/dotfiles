local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
  options = {
    numbers = "none",
    close_command = "Bdelete! %d",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = { icon = "▎", style = "icon" },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 30,
    max_prefix_length = 30,
    tab_size = 21,
    diagnostics = false,
    diagnostics_update_in_insert = false,
    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "thin",
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  },
  highlights = {
    -- fg/bg color for tabline area
    fill = {
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of a buffer when not focused
    background = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of main close button (most right button)
    tab_close = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of close button for unfocused buffers
    close_button = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color for close button of current buffer when another window/tab is focused
    close_button_visible = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color for close button of current buffer when focused
    close_button_selected = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- fg/bg color of current buffer when another window/tab is focused
    buffer_visible = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of current buffer
    buffer_selected = {
      fg = { attribute = "fg", highlight = "TabLine" },
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- fg/bg color of close button for unfocused (modified) buffer
    modified = {
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of close button for current (modified) buffer when another window/tab is focused
    modified_visible = {
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- fg/bg color of close button for current (modified) buffer
    modified_selected = {
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- fg/bg color of separator area between buffers
    separator = {
      fg = { attribute = "bg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of indicator area when not focused
    indicator_visible = {
      fg = { attribute = "bg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    -- fg/bg color of indicator area when focused
    indicator_selected = {
      bg = { attribute = "bg", highlight = "TabLine" },
    },
    -- Not sure if these are necessary
    -- separator_selected = { }
    -- separator_visible = { }
    -- tab = { }
    -- tab_selected = { }
    -- pick = { }
    -- pick_visible = { }
    -- offset_separator = { }
    -- duplicate = { }
    -- duplicate_selected = { }
    -- duplicate_visible = { }

    -- Other highlights that are currently disabled due to option settings
    -- See options.numbers = "none" and options.diagnostics = false
    -- numbers = { }
    -- numbers_visible = { }
    -- numbers_selected = { }
    -- diagnostic = { }
    -- diagnostic_visible = { }
    -- diagnostic_selected_ = { }
    -- hint = { }
    -- hint_visible = { }
    -- hint_selected = { }
    -- hint_diagnostic = { }
    -- hint_diagnostic_visible = { }
    -- hint_diagnostic_selected = { }
    -- info = { }
    -- info_visible = { }
    -- info_selected = { }
    -- info_diagnostic = { }
    -- info_diagnostic_visible = { }
    -- info_diagnostic_selected = { }
    -- warning = { }
    -- warning_visible = { }
    -- warning_selected = { }
    -- warning_diagnostic = { }
    -- warning_diagnostic_visible = { }
    -- warning_diagnostic_selected = { }
    -- error = { }
    -- error_visible = { }
    -- error_selected = { }
    -- error_diagnostic = { }
    -- error_diagnostic_visible = { }
    -- error_diagnostic_selected = { }
  },
})
