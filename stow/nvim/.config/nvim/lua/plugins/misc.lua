return {
	-- Fuzzy finder and utilities
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},
	{ "ibhagwan/fzf-lua" },

	-- Comment toggling
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"dashboard",
					"alpha",
					"starter",
				},
				buftypes = {
					"terminal",
					"nofile",
				},
			},
		},
	},

	-- Surround text objects easily
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	-- Git integration
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-rhubarb" },

	-- Emmet for HTML/CSS
	{ "mattn/emmet-vim" },
}
