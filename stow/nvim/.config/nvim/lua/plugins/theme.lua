return {
	--[[ {
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
	},
	--]]
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
	},

	--[[ {
		'zenbones-theme/zenbones.nvim',
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000
	},
	--]]

	--[[ 	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
	},
	--]]

	-- The nord theme and completion UI
	--[=[
	{
		'shaunsingh/nord.nvim',
		config = function()
			vim.cmd([[colorscheme nord]])

			-- Completion UI colors
			local hl = vim.api.nvim_set_hl

			hl(0, "CmpPmenu",         { bg = "#2E3440" })
			hl(0, "CmpSel",           { bg = "#3B4252", bold = true })

			hl(0, "CmpItemAbbr",      { fg = "#ECEFF4" })
			hl(0, "CmpItemAbbrMatch", { fg = "#88C0D0", bold = true })
			hl(0, "CmpItemMenu",      { fg = "#81A1C1", italic = true })

			hl(0, "CmpItemKindFunction", { fg = "#88C0D0" })
			hl(0, "CmpItemKindMethod",   { fg = "#88C0D0" })
			hl(0, "CmpItemKindVariable", { fg = "#D8DEE9" })
			hl(0, "CmpItemKindClass",    { fg = "#8FBCBB" })
			hl(0, "CmpItemKindKeyword",  { fg = "#81A1C1" }) 

		end
	},

	--]=]
	--[[ {
		'catppuccin/nvim', name = "catppuccin",
		config = function() 
			require'catppuccin'.setup {
				flavour = "frappe",
				transparent_background = true,
				styles = {
					comments = { 'italic' },
					conditionals = { 'italic' },
				},
				auto_integrations = true,
			}
		end
	},
	--]]
}
