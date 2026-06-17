return {

	-- The file explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = { width = 30 },
				git = { enable = true },
				renderer = {
					icons = {
						glyphs = {
							folder = {
								arrow_closed = "▶",
								arrow_open = "▼",
							},
						},
					},
				},
			})
		end,
	},

	-- The status bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({ options = { theme = "nord" } })
		end,
	},
	{
		"romus204/tree-sitter-manager.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = { "TSInstall", "TSUpdate", "TSManager" },
		opts = {
			ensure_installed = {
				"c",
				"cpp",
				"bash",
				"asm",
				"smali",
				"typescript",
				"html",
				"css",
				"javascript",
				"go",
				"kotlin",
				"gnuplot",
				"haskell",
				"yaml",
				"markdown",
			},
		},
		config = function(_, opts)
			require("tree-sitter-manager").setup(opts)

			-- Autocommand to trigger highlighting (now natively supported)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)

					local ignore_ft = { "notify", "gas" }

					for _, name in ipairs(ignore_ft) do
						if ft == name then
							return
						end
					end

					if lang then
						-- Start treesitter only if a parser exists
						pcall(vim.treesitter.start, args.buf, lang)
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { max_lines = 3, seperator = "-", zindex = 20, mode = "cursor" },
	},

	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{ "danilamihailov/beacon.nvim" },
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinLeave" },
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					avoid = {
						"NvimTree",
					},
					relative = "editor",
				},
			},
		},
	},
	{
		"kevinhwang91/nvim-ufo",
		config = function()
			require("ufo").setup()
		end,
		dependencies = { { "kevinhwang91/promise-async" } },
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				fps = 60,
				timeout = 2000,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
