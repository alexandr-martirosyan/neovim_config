local M = {}

M.opts = {}

M.keys = {
	{ "<leader>wK", "<cmd>WhichKey <CR>", mode = "n", desc = "whichkey all keymaps" },
	{
		"<leader>wk",
		function()
			vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
		end,
		mode = "n",
		desc = "whichkey query lookup",
	},
	{
		"<leader>?",
		function()
			require("which-key").show({ global = false })
		end,
		mode = "n",
		desc = "Buffer Local Keymaps (which-key)",
	},
}

return M
