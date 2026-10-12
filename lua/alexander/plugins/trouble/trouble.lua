local M = {}

M.opts = {}

-- M.config = function(_, opts)
-- 	local actions = require("telescope.actions")
-- 	local open_with_trouble = require("trouble.sources.telescope").open

-- 	-- Use this to add more results without clearing the trouble list
-- 	local add_to_trouble = require("trouble.sources.telescope").add

-- 	local telescope = require("telescope")

-- 	telescope.setup({
-- 		defaults = {
-- 			mappings = {
-- 				i = { ["<c-t>"] = open_with_trouble },
-- 				n = { ["<c-t>"] = open_with_trouble },
-- 			},
-- 		},
-- 	})
-- end

M.keys = {
	{ "<leader>zx", "<cmd>Trouble diagnostics toggle<cr>", mode = "n", desc = "Diagnostics (Trouble)" },
	{
		"<leader>zX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		mode = "n",
		desc = "Buffer Diagnostics (Trouble)",
	},
	{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", mode = "n", desc = "Symbols (Trouble)" },
	{
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		mode = "n",
		desc = "LSP Definitions / references / ... (Trouble)",
	},
	{ "<leader>zL", "<cmd>Trouble loclist toggle<cr>", mode = "n", desc = "Location List (Trouble)" },
	{ "<leader>zQ", "<cmd>Trouble qflist toggle<cr>", mode = "n", desc = "Quickfix List (Trouble)" },
}

return M
