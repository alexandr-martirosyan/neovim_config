local gitsigns = require("alexander.plugins.gitsigns.gitsigns")

local M = {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		keys = gitsigns.keys,
		opts = gitsigns.opts,
	},
}

return M
