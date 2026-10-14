local M = {}

M.opts = {
	-- Names for the <leader> groups in the popup (instead of "+N keymaps"). Labels only; the keys are
	-- defined in each plugin's file.
	spec = {
		{ "<leader>b", group = "Buffers (barbar)" },
		{ "<leader>c", group = "Code (Trouble) / commits" },
		{ "<leader>d", group = "Diagnostics / database" },
		{ "<leader>f", group = "Find / format / replace" },
		{ "<leader>g", group = "Git (gitsigns)" },
		{ "<leader>i", group = "AI" },
		{ "<leader>ia", group = "Avante" },
		{ "<leader>ic", group = "CodeCompanion" },
		{ "<leader>j", group = "Harpoon" },
		{ "<leader>l", group = "Lines / lint / LSP / LazyGit" },
		{ "<leader>m", group = "Marks" },
		{ "<leader>n", group = "Neogit" },
		{ "<leader>p", group = "Terminals" },
		{ "<leader>R", group = "HTTP requests (Kulala)" },
		{ "<leader>s", group = "Splits" },
		{ "<leader>t", group = "Toggles" },
		{ "<leader>w", group = "Which-key" },
		{ "<leader>z", group = "Trouble lists" },
	},
}

M.keys = {
	{ "<leader>wK", "<cmd>WhichKey <CR>", mode = "n", desc = "whichkey all keymaps" },
	{
		"<leader>wk",
		function()
			local key = vim.fn.input("WhichKey: ")
			if key ~= "" then -- Esc / empty: do nothing (instead of showing every key)
				vim.cmd("WhichKey " .. key)
			end
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
