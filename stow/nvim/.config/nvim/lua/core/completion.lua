local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load friendly-snippets for luasnip
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- Use LuaSnip for snippets
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion menu
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})
