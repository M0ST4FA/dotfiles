return {

  -- The file explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        git = { enable = true },
        renderer = {
          icons = {
            glyphs = {
              folder = {
                arrow_closed = "▶",
                arrow_open = "▼"
              }
            }
          }
        }
      })
    end
  },

  -- The status bar
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({ options = { theme = 'nord' } })
    end
  },

  -- The nord theme
  {
  'shaunsingh/nord.nvim',
  config = function()
    vim.cmd([[colorscheme nord]])
  end
  },

  -- Better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },
}

