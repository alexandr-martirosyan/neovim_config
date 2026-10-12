local M = {}

M.opts = {
	integrations = { telescope = true, diffview = true, fzf_lua = false, mini_pick = false },
	mappings = {
		-- Setting any of these to `false` will disable the mapping.
		popup = {
			["l"] = false,
			["<leader>l"] = "LogPopup",
		},
	},
}
M.keys = {
	{ "<leader>ng", "<CMD>Neogit<CR>", mode = "n", desc = "Open Neogit tab" },
}

return M
