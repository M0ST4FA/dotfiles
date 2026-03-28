if not vim.g.neovide then
  return
end

-- Display
vim.g.neovide_pixel_geometry = "RGBH"
vim.g.neovide_scale_factor = 0.85
vim.g.neovide_padding_top = 10
vim.g.neovide_padding_left = 5

-- Theme
vim.g.neovide_normal_opacity = 0.5

-- Functionality
vim.g.neovide_fullscreen = false
vim.g.neovide_profiler = false

-- Cursor
vim.g.neovide_cursor_animation_length = 0.13

vim.g.neovide_cursor_smooth_blink = true

vim.g.neovide_cursor_trail_size = 0.8

-- Cusor particles
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_speed = 20.0
vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
vim.g.neovide_cursor_vfx_particle_density = 10.0
vim.g.neovide_cursor_vfx_particle_phase = 3
vim.g.neovide_cursor_vfx_particle_curl = 1
