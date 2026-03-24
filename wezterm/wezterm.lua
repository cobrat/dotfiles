local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font_with_fallback {
    'Monaspace Argon',
    'Symbols Nerd Font',
}
config.font_size = 14.0

-- Color scheme
config.color_scheme = 'Gruvbox Dark (Gogh)'

-- Window
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.window_padding = {
    left = 18,
    right = 18,
    top = 48,
    bottom = 12,
}

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.tab_max_width = 32

-- Cursor
config.default_cursor_style = 'BlinkingBlock'

-- Performance
config.max_fps = 120
config.animation_fps = 60
config.front_end = 'WebGpu'

-- Scrollback
config.scrollback_lines = 10000

-- macOS Option key
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Hyperlinks
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Bell
config.audible_bell = 'Disabled'
config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
}

-- Auto reload config
config.automatically_reload_config = true

-- Mouse
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = wezterm.action.PasteFrom 'Clipboard',
    },
}

return config
