-- This is the main configuration file for WezTerm.

local wezterm = require 'wezterm'  -- Ensure this line is at the top to load wezterm module

return {
  -- Set the font to Nerd Font or any other font you want
  font = wezterm.font_with_fallback({
    'FiraCode Nerd Font',
    'Symbols Nerd Font',
  }),
  font_size = 12.0,
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

  -- Use a color scheme like 'Gruvbox Dark'
  -- color_scheme = 'Mariana',
  color_scheme = 'nord',

  -- Customize the cursor style to Underlined
  cursor_thickness = 2.0,  -- Set cursor thickness to 2
  cursor_blink_rate = 500,
  cursor_blink_ease_in = "Linear",
  cursor_blink_ease_out = "Linear",

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

  -- Optional: Set padding for the window
  window_padding = { left = 10, right = 10, top = 10, bottom = 10 },

  -- Enable and configure some other features if needed
  window_background_opacity = 0.95,  -- Semi-transparent background (optional)
  -- use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true, 
}

