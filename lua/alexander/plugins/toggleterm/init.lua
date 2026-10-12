local toggleterm = require("alexander.plugins.toggleterm.toggleterm")

local M = {
	{
		"akinsho/toggleterm.nvim",
		version = "*", -- docs (and your original setting)
		cmd = { "ToggleTerm", "TermSelect" },
		keys = toggleterm.keys,
		opts = toggleterm.opts,
	},
}

return M
