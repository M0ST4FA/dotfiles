vim.opt.number = true
vim.wo.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.pumheight = 5
vim.cmd([[
  syntax enable
  filetype plugin indent on
]])

-- Clipboard for Wayland
vim.g.clipboard = {
	name = "wl-clipboard",
	copy = {
		["+"] = "wl-copy",
		["*"] = "wl-copy",
	},
	paste = {
		["+"] = "wl-paste",
		["*"] = "wl-paste",
	},
	cache_enabled = 0,
}
vim.opt.clipboard = "unnamedplus"

-- Keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Folding
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldcolumn = "1"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Filetypes
vim.filetype.add({
	extension = {
		S = "gas",
		lua = "lua",
	},
})
vim.lsp.config.asm_lsp = {
	filetypes = { "gas" },
}

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded" },
})

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
	pattern = "haskell",
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.shiftwidth = 2 -- 2 is the Haskell idiom
		vim.opt_local.softtabstop = 2
		vim.opt_local.tabstop = 2
	end,
})
