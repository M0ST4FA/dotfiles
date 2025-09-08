return {

  -- Code outline sidebar
  {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup({
        backends = { "lsp", "treesitter", "markdown" },
        on_attach = function(bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
        end,
      })
    end
  },

  -- Floating terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require("toggleterm").setup{
        size = 20,
        open_mapping = [[<c-\>]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        direction = 'horizontal'
      }
    end
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end
  },

  -- Code formatter
  {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({

        formatters = {

          injected = {
            options = {
              ignore_errors = false,
              lang_to_formatters = {
                sql = { "sqlfluff" },
              },
              lang_to_ext = {
                sql = "sql",
              },
            },
          },

          sqlfluff = {
            command = "/usr/bin/sqlfluff",
            args = { "fix", "--stdin-filepath", "$FILENAME", "--", "-" },
          }, 
        },

        formatters_by_ft = {
          html = { "prettier" },
          css = { "prettier" },
          javascript = { "prettier" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          python = { "black" },
          sql = { "sqlfluff", "injected" }
        },
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          require("conform").format()
        end,
      })
    end
  },

  -- Autopairing
  {
    'windwp/nvim-autopairs',
    config = function()
      require("nvim-autopairs").setup {}
    end
  },


  -- Git signs in gutter
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
}

