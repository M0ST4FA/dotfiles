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
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),  -- Scroll docs up
    ["<C-f>"] = cmp.mapping.scroll_docs(4),   -- Scroll docs down
    ["<C-Space>"] = cmp.mapping.complete(),   -- Trigger completion menu
    ["<C-e>"] = cmp.mapping.abort(),           -- Close completion window
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

