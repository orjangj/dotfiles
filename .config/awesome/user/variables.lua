local variables = {
  altkey = "Mod1",
  browser = "firefox",
  compositor = "compton -b",
  editor = os.getenv("EDITOR") or "nvim",
  file_manager = "ranger",
  modkey = "Mod4",
  tags = { count = 5, glyphs = { "", "", "", "", "" } },
  terminal = "kitty",
  terminal_opacity = 0.95,
  theme = "nord",
  wallpapers = os.getenv("HOME") .. "/.local/share/backgrounds/wallpapers/nord",
}

return variables
