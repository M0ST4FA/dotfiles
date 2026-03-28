vim.opt.number = true
vim.wo.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.pumheight = 5
vim.cmd [[
  syntax enable
  filetype plugin indent on
]]


-- Clipboard for Wayland
vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy',
  },
  paste = {
    ['+'] = 'wl-paste',
    ['*'] = 'wl-paste',
  },
  cache_enabled = 0,
}
vim.opt.clipboard = 'unnamedplus'

-- Keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Folding
vim.opt.foldenable = true
vim.opt.foldmethod = 'expr'
vim.opt.foldcolumn = '1'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
