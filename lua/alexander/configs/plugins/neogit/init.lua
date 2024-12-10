local M = {}

M.opts = {
	mappings = {
		-- Setting any of these to `false` will disable the mapping.
		popup = {
			["l"] = false,
			["<leader>l"] = "LogPopup",
		},
	},
}
return M
