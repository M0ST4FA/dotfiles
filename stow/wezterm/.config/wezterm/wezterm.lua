-- This is the main configuration file for WezTerm.

local wezterm = require 'wezterm'  -- Ensure this line is at the top to load wezterm module
local config = wezterm.config_builder()

local bar = wezterm.plugin.require 'https://github.com/adriankarlen/bar.wezterm'
-- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

config.term = "wezterm"

-- Set the font to Nerd Font or any other font you want
config.font = wezterm.font_with_fallback({
  'FiraCode Nerd Font',
})
config.font_size = 12.0
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- color_scheme = 'Mariana',
config.color_scheme = "Noctalia"

-- Customize the cursor style to Underlined
config.cursor_thickness = 2.0  -- Set cursor thickness to 2
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"

-- Set the background color and foreground color
-- colors = {
  --  foreground = "#c5c8c6",  -- Light gray text
  --  background = "#2d2a2e",  -- Dark background similar to Kali
  --  cursor_bg = "#f8f8f2",   -- Light cursor
  --  cursor_border = "#f8f8f2",
  --  cursor_fg = "#2d2a2e",   -- Dark cursor text
  --  selection_bg = "#f8f8f2",
  --  selection_fg = "#2d2a2e",
  --},

config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }

config.window_background_opacity = 0.70

-- Bar
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
-- config.show_close_tab_button_in_tabs = false

local bar_config = {
  position = "bottom",
  max_width = 32,
  padding = {
    left = 0,
    right = 1,
    tabs = {
      left = 0,
      right = 2,
    },
  },
  separator = {
    space = 0,
    left_icon = ':',
    right_icon = wezterm.nerdfonts.fa_long_arrow_left,
    field_icon = wezterm.nerdfonts.indent_line,
  },
  modules = {
    tabs = {
      active_tab_fg = 4,
      inactive_tab_fg = 6,
      new_tab_fg = 2,
    },
    workspace = {
      enabled = false,
    },
    leader = {
      enabled = true,
      icon = wezterm.nerdfonts.oct_rocket,
      color = 2,
    },
    pane = {
      enabled = false,
      icon = wezterm.nerdfonts.cod_multiple_windows,
      color = 7,
    },
    username = {
      enabled = false,
      icon = '',
      color = 6,
    },
    hostname = {
      enabled = false,
      icon = wezterm.nerdfonts.cod_server,
      color = 8,
    },
    clock = {
      enabled = false,
    },
    cwd = {
      enabled = false,
    }
  },
}

-- bar.apply_to_config(config, bar_config)

return config
