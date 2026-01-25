local toggleterm = require("alexander.plugins.toggleterm.toggleterm")

local M = {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm" },
		opts = toggleterm.opts,
	},
}

return M
