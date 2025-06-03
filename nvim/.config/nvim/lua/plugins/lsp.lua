return {
  { 'neovim/nvim-lspconfig', config = function()
    require('lspconfig').clangd.setup{}
    require('lspconfig').pyright.setup{}
    require('lspconfig').ts_ls.setup{}
  end },
   -- Completion engine
  { "hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = {

    -- nvim-cmp friends
    -- LSP source for nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
    -- Buffer completions
    "hrsh7th/cmp-buffer",
    -- File path completions
    "hrsh7th/cmp-path",
    'hrsh7th/cmp-cmdline',

    -- Snippet engine and sources
    -- Snippet completions
    "saadparwaiz1/cmp_luasnip",
    -- LuaSnip snippets engine
    "L3MON4D3/LuaSnip",
    -- Useful snippet collection
    "rafamadriz/friendly-snippets",
  }},
}
