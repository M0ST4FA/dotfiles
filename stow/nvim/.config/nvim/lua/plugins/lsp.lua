return {
  { 'neovim/nvim-lspconfig', 
    config = function()

      -- --- Configure individual servers using the modern vim.lsp.config API ---

      -- Define configurations for each server:
      vim.lsp.config.clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=never" },
          init_options = { clangdFileStatus = true },
      }

      -- --- Enable Servers using the modern API ---
      -- This tells Neovim to start all configured servers when the appropriate filetype is opened.
      vim.lsp.enable({
        "clangd",
        "pyright",
        "bashls",
        "html",
        "cssls",
        "tsserver",
      })

    end
},
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
