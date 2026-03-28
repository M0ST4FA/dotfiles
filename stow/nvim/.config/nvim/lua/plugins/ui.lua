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
  --[=[
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
  --]=]
  {
    'catppuccin/nvim', name = "catppuccin",
    config = function() 
      require'catppuccin'.setup {
        flavour = "frappe",
        transparent_background = true,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
        },
        auto_integrations = true,
      }
    end
  },

  -- Better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter'.setup {
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
  {
    'HiPhish/rainbow-delimiters.nvim'
  },
{ 'danilamihailov/beacon.nvim' },
{
  "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
{
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
         enable = true,
        },
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
        },
      },
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
  },
{
  "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          avoid = {
            "NvimTree"
          },
          relative = 'editor',
        }
      }
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    config = function()
      require('ufo').setup()
    end,
    dependencies = { {'kevinhwang91/promise-async'} }
  },

{
  'rcarriga/nvim-notify',
  config = function() 
    require('notify').setup({
      fps = 60,
      timeout = 2000,
    })
  end
  },
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  }

}

