local M = {}

M.opts = {
	keywords = {
		TODO = {
			alt = { "todo" },
		},
	},
	highlight = {
		comments_only = false,
	},
}

M.keys = {
	{ "<leader>ft", "<cmd>TodoTelescope<CR>", mode = "n", desc = 'telescope find "TODO"-s' },
	{
		"]t",
		function()
			require("todo-comments").jump_next()
		end,
		mode = "n",
		desc = "Next todo comment",
	},
	{
		"[t",
		function()
			require("todo-comments").jump_prev()
		end,
		mode = "n",
		desc = "Previous todo comment",
	},
}

return M
