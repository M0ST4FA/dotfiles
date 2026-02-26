vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

vim.keymap.set('n', '<C-f>', ':FzfLua live_grep<CR>')

-- This autocommand runs every time an LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf, noremap = true, silent = true }

    -- Goto Shortcuts
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)      -- [G]oto [D]efinition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)     -- [G]oto [D]eclaration
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)      -- [G]oto [R]eferences
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)  -- [G]oto [I]mplementation
    
    -- Information & Actions
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)            -- Hover doc
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)  -- Rename symbol
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code Action
    
    -- Diagnostic Shortcuts
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts) -- Show error details
    
    -- Optional: Debug notification to confirm it's working
    vim.notify("LSP Attached: " .. vim.lsp.get_client_by_id(event.data.client_id).name)
  end,
})

