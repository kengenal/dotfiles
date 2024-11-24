-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()


-- For example, changing the color scheme:
config.color_scheme = 'Gnometerm'
config.font = wezterm.font("CaskaydiaCove Nerd Font", {weight="DemiBold", stretch="Normal", style="Normal"})
config.window_background_image = wezterm.home_dir .. '/Pictures/wallpapers/894677.jpg'
config.window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = 0.030,

    -- You can adjust the hue by scaling its value.
    -- a multiplier of 1.0 leaves the value unchanged.
    hue = 1.0,

    -- You can adjust the saturation also.
    saturation = 1.0,
}
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.font_size = 20.0
config.initial_rows = 100
config.initial_cols = 200
-- config.window_background_opacity = 0.98

config.max_fps = 165
config.enable_scroll_bar = true

-- and finally, return the configuration to wezterm
return config
