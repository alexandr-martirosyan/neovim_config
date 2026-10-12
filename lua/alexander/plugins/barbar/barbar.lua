local M = {}

M.init = function()
	vim.g.barbar_auto_setup = false
end
M.opts = {
	icons = {
		button = "",
		-- Enables / disables diagnostic symbols
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = true },
			[vim.diagnostic.severity.WARN] = { enabled = true },
			[vim.diagnostic.severity.INFO] = { enabled = true },
			[vim.diagnostic.severity.HINT] = { enabled = true },
		},

		-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
		preset = "slanted",
	},
	filename_depth = 1,

	-- Set the filetypes which barbar will offset itself for
	sidebar_filetypes = {
		-- Or, specify the event which the sidebar executes when leaving:
		["neo-tree"] = { event = "BufWipeout", text = "File Explorer", align = "center" },
	},
}

M.keys = {
	-- Move to previous/next
	{ "<S-h>", "<Cmd>BufferPrevious<CR>", mode = "n", desc = "buffer goto previous" },
	{ "<S-l>", "<Cmd>BufferNext<CR>", mode = "n", desc = "buffer goto next" },
	-- Re-order to previous/next
	{ "<A-,>", "<Cmd>BufferMovePrevious<CR>", mode = "n", desc = "buffer move previous" },
	{ "<A-.>", "<Cmd>BufferMoveNext<CR>", mode = "n", desc = "buffer move next" },
	-- Goto buffer in position...
	{ "<A-0>", "<Cmd>BufferLast<CR>", mode = "n", desc = "buffer goto last" },
	-- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
	-- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
	-- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
	-- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
	-- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
	-- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
	-- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
	-- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
	-- Pin/unpin buffer
	-- was <A-p>; that key is vim-illuminate's "previous reference"
	{ "<leader>bp", "<Cmd>BufferPin<CR>", mode = "n", desc = "buffer pin" },
	-- Goto pinned/unpinned buffer
	--                 :BufferGotoPinned
	--                 :BufferGotoUnpinned
	-- Close buffer
	{ "<leader>x", "<Cmd>BufferClose<CR>", mode = "n", desc = "buffer close" },
	-- Wipeout buffer
	--                 :BufferWipeout
	-- Close commands
	--                 :BufferCloseAllButCurrent
	--                 :BufferCloseAllButPinned
	--                 :BufferCloseAllButCurrentOrPinned
	--                 :BufferCloseAllButVisible
	--                 :BufferCloseBuffersLeft
	--                 :BufferCloseBuffersRight
	-- Close buffer mappings
	{
		"<leader>ba",
		"<Cmd>BufferCloseAllButCurrentOrPinned<CR>",
		mode = "n",
		desc = "Close every buffer except pinned or current",
	},
	{ "<leader>bv", "<Cmd>BufferCloseAllButVisible<CR>", mode = "n", desc = "Close every buffer except visible" },
	-- Magic buffer-picking mode
	{ "<A-S-p>", "<Cmd>BufferPick<CR>", mode = "n", desc = "buffer pick" },
	-- Sort automatically by...
	{ "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", mode = "n", desc = "buffer order by buffer number" },
	{ "<leader>bn", "<Cmd>BufferOrderByName<CR>", mode = "n", desc = "buffer order by name" },
	{ "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", mode = "n", desc = "buffer order by directory" },
	{ "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", mode = "n", desc = "buffer order by language" },
	{ "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", mode = "n", desc = "buffer order by window number" },
}

return M
