vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

vim.keymap.set("n", "<C-f>", ":FzfLua live_grep<CR>")

-- This autocommand runs every time an LSP attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf, noremap = true, silent = true }
		local wk = require("which-key")

		-- Goto Shortcuts
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, opts)
		vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, opts) -- Rename symbol
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts) -- Code Action
		wk.add({
			{ "<leader>l", group = "LSP" },
			{ "<leader>ld", desc = "Definitions" },
			{ "<leader>lD", desc = "Declarations" },
			{ "<leader>lr", desc = "References" },
			{ "<leader>li", desc = "Implementations" },
			{ "<leader>ls", desc = "Document symbols" },
			{ "<leader>lk", desc = "Hover" },
			{ "<leader>lR", desc = "Rename symbol" },
			{ "<leader>la", desc = "Code action" },
		})

		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				local word = vim.fn.expand("<cword>")
				vim.cmd("Man " .. word)
			end
		end, opts) -- Hover doc

		-- Diagnostic Shortcuts
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show error details

		vim.notify("LSP Attached: " .. vim.lsp.get_client_by_id(event.data.client_id).name)
	end,
})

local wk = require("which-key")

-- Folding
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zp", require("ufo").peekFoldedLinesUnderCursor)

wk.add({
	{ "<leader>z", group = "Folding" },
	{ "<leader>zR", desc = "Open all folds" },
	{ "<leader>zM", desc = "Close all folds" },
	{ "<leader>zp", desc = "Peek folded under cursor" },
})

-- File navigation
local tbuiltin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tbuiltin.find_files)
vim.keymap.set("n", "<leader>fr", tbuiltin.oldfiles)
vim.keymap.set("n", "<leader>fb", tbuiltin.buffers)
vim.keymap.set("n", "<leader>fc", tbuiltin.commands)

wk.add({
	{ "<leader>f", group = "File navigation" },
	{ "<leader>fb", desc = "Buffers" },
	{ "<leader>fc", desc = "Commands" },
	{ "<leader>ff", desc = "Find file" },
	{ "<leader>fr", desc = "Recent files" },
})

-- Project search
vim.keymap.set("n", "<leader>sg", tbuiltin.live_grep)
vim.keymap.set("n", "<leader>sw", tbuiltin.grep_string)
vim.keymap.set("n", "<leader>sh", tbuiltin.help_tags)

wk.add({
	{ "<leader>s", group = "Project Search" },
	{ "<leader>sg", desc = "Live grep" },
	{ "<leader>sh", desc = "Help tags" },
	{ "<leader>sw", desc = "Search word under cursor" },
})

-- Git navigation
vim.keymap.set("n", "<leader>gc", tbuiltin.git_commits)
vim.keymap.set("n", "<leader>gb", tbuiltin.git_branches)
vim.keymap.set("n", "<leader>gs", tbuiltin.git_status)

wk.add({
	{ "<leader>g", group = "Git" },
	{ "<leader>gb", desc = "Branches" },
	{ "<leader>gc", desc = "Commits" },
	{ "<leader>gs", desc = "Status" },
})

-- Neovim introspection
vim.keymap.set("n", "<leader>hk", tbuiltin.keymaps)
vim.keymap.set("n", "<leader>hc", tbuiltin.commands)
vim.keymap.set("n", "<leader>ho", tbuiltin.vim_options)

wk.add({
	{ "<leader>h", group = "Help" },
	{ "<leader>hc", desc = "Commands" },
	{ "<leader>hk", desc = "Keymaps" },
	{ "<leader>ho", desc = "Options" },
})
