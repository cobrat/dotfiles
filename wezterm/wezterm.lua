local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'Monaspace Argon'
config.font_size = 14.0

config.color_scheme = 'Tokyo Night'

config.window_background_opacity = 1.0
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'

config.hide_tab_bar_if_only_one_tab = true

config.default_cursor_style = 'BlinkingBlock'

config.scrollback_lines = 5000

config.window_padding = {
    left = 18,
    right = 18,
    top = 48,
    bottom = 12,
}

return config
