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

  -- The nord theme and completion UI
  {
  'shaunsingh/nord.nvim',
  config = function()
    vim.cmd([[colorscheme nord]])

    -- Completion UI colors
    local hl = vim.api.nvim_set_hl

    hl(0, "CmpPmenu",         { bg = "#2E3440" })
    hl(0, "CmpSel",           { bg = "#3B4252", bold = true })

    hl(0, "CmpItemAbbr",      { fg = "#ECEFF4" })
    hl(0, "CmpItemAbbrMatch", { fg = "#88C0D0", bold = true })
    hl(0, "CmpItemMenu",      { fg = "#81A1C1", italic = true })

    hl(0, "CmpItemKindFunction", { fg = "#88C0D0" })
    hl(0, "CmpItemKindMethod",   { fg = "#88C0D0" })
    hl(0, "CmpItemKindVariable", { fg = "#D8DEE9" })
    hl(0, "CmpItemKindClass",    { fg = "#8FBCBB" })
    hl(0, "CmpItemKindKeyword",  { fg = "#81A1C1" }) 

  end
  },

  -- Better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- Parsers to install
        ensure_installed = {
          "c",
          "cpp",
          "bash",
          "html",
          "css",
          "javascript",
          "typescript",
          "go",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },
}

