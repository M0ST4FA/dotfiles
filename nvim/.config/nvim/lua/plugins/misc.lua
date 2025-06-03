return {
  -- Fuzzy finder and utilities
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Comment toggling
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },

  -- Indentation guides
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- Icons for filetypes etc.
  { 'nvim-tree/nvim-web-devicons' },

  -- Surround text objects easily
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },

  -- Git integration
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },

  -- Emmet for HTML/CSS
  { 'mattn/emmet-vim' },

  -- Color highlighter for CSS etc.
  { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end },
}

