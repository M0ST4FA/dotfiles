return {
  { 'neovim/nvim-lspconfig', 
    config = function()

      -- --- Configure individual servers using the modern vim.lsp.config API ---

      -- Define configurations for each server:
      vim.lsp.config.clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=never" },
          init_options = {
            fallbackFlags = { '-std=c++20', '-std=c23' },
          },
          init_options = { clangdFileStatus = true },
          on_attach = function(client, bufnr)
            local opts = {
              noremap = true,        -- Don't remap recursively
              silent = true,         -- Don't show the command in the command bar
              buffer = true,         -- Only apply to the current buffer (essential for LSP)
              desc = "LSP: Rename symbol" -- Description for help menus
            }

            -- Rename the symbol under the cursor
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          end
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
