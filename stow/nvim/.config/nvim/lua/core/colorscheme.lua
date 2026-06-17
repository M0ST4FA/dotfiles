--[=[ require('tokyonight').setup({
	style = "moon", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  light_style = "light", -- The theme is used when the background is set to light
  transparent = true, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "transparent", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights tokyonight.Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,

  cache = true, -- When set to true, the theme will be cached for better performance

  ---@type table<string, boolean|{enabled:boolean}>
  plugins = {
    -- enable all plugins when not using lazy.nvim
    -- set to false to manually enable/disable plugins
    all = package.loaded.lazy == nil,
    -- uses your plugin manager to automatically enable needed plugins
    -- currently only lazy.nvim is supported
    auto = true,
    -- add any plugins here that you want to enable
    -- for all possible plugins, see:
    --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
    -- telescope = true,
  },
    })

vim.cmd([[colorscheme tokyonight-moon]])
--]=]

require("nordic").setup({
	bold_keywords = true,
	italic_comments = false, -- better readability
	transparent = {
		bg = true,
		float = false,
	},
	bright_border = true,
	reduced_blue = true, -- IMPORTANT for eye comfort
	swap_backgrounds = true,

	cursorline = {
		bold = false,
		bold_number = true,
		theme = "dark",
		blend = 0.85,
	},

	visual = {
		bold = false,
		bold_number = true,
		theme = "dark",
		blend = 0.85,
	},

	telescope = {
		style = "flat",
	},

	noice = {
		style = "classic",
	},

	ts_context = {
		dark_background = false,
	},

	on_highlights = function(hl, c)
		--------------------------------------------------
		-- 🧾 Comments (FIXED PROBLEM AREA)
		--------------------------------------------------
		hl.Comment = { fg = c.gray2, italic = false }
		hl["@comment"] = { fg = c.gray2, italic = false }

		hl["@comment.todo"] = { fg = c.yellow, bold = true }
		hl["@comment.note"] = { fg = c.blue1, bold = true }
		hl["@comment.warning"] = { fg = c.orange, bold = true }
		hl["@comment.error"] = { fg = c.red, bold = true }

		--------------------------------------------------
		-- 🔑 Keywords / Control Flow
		--------------------------------------------------
		hl.Keyword = { fg = c.purple, bold = true }
		hl["@keyword"] = { fg = c.purple, bold = true }

		--------------------------------------------------
		-- ⚙️ Functions
		--------------------------------------------------
		hl.Function = { fg = c.blue1, bold = false }
		hl["@function"] = { fg = c.blue1 }

		--------------------------------------------------
		-- 🧱 Types (VERY IMPORTANT in C/kernel)
		--------------------------------------------------
		hl.Type = { fg = c.yellow, bold = false }
		hl["@type"] = { fg = c.yellow }

		--------------------------------------------------
		-- 🔢 Constants / Macros
		--------------------------------------------------
		hl.Constant = { fg = c.orange }
		hl["@constant"] = { fg = c.orange }

		--------------------------------------------------
		-- 🧵 Strings
		--------------------------------------------------
		hl.String = { fg = c.green }
		hl["@string"] = { fg = c.green }

		--------------------------------------------------
		-- 🔍 Variables (keep neutral)
		--------------------------------------------------
		hl.Identifier = { fg = c.fg }
		hl["@variable"] = { fg = c.fg }

		--------------------------------------------------
		-- ⚠️ Diagnostics (LSP)
		--------------------------------------------------
		hl.DiagnosticError = { fg = c.red, bold = true }
		hl.DiagnosticWarn = { fg = c.orange }
		hl.DiagnosticInfo = { fg = c.blue1 }
		hl.DiagnosticHint = { fg = c.gray2 }

		--------------------------------------------------
		-- 📌 Cursor & Visual clarity
		--------------------------------------------------
		hl.CursorLine = { bg = c.bg_dark }
		hl.CursorLineNr = { fg = c.yellow, bold = true }

		--------------------------------------------------
		-- 🪟 Floating windows (important for LSP UX)
		--------------------------------------------------
		hl.NormalFloat = { bg = c.bg_dark }
		hl.FloatBorder = { fg = c.blue1, bg = c.bg_dark }
	end,
})

vim.cmd([[colorscheme nordic]])

-- vim.g.nordbones = {
-- 	transparent_background = true,
-- 	colorize_diagnostic_underline_text = true,
-- 	darken_comments = true,
-- }
-- vim.api.nvim_set_hl(0, 'Normal', { bg = '#2e3440' }) -- Set background color to nord0
