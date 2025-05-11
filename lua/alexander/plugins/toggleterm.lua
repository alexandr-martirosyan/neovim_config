local toggleterm = require("alexander.configs.plugins.toggleterm")

local M = {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm" },
		opts = toggleterm.opts,
	},
}

return M
