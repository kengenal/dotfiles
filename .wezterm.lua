-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()


-- For example, changing the color scheme:
config.color_scheme = 'Gruvbox dark, hard (base16)'
-- config.window_background_image = wezterm.home_dir .. '/Pictures/Wallpapers/standard/security-break-grim-reaper-hacker-qj-2560x1440.jpg'
config.window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = 0.030,
    hue = 1.0,
    saturation = 1.0,
}
config.colors = {
    background = '#000000',
}
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.font_size = 20.0
config.initial_rows = 100
config.initial_cols = 200
config.window_background_opacity = 0.85
config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')

config.max_fps = 165
config.enable_scroll_bar = true
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 15,
}
config.enable_scroll_bar = false

-- and finally, return the configuration to wezterm
return config
