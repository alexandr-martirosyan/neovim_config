local gitsigns = require "alexander.plugins.gitsigns.gitsigns"

local M = {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		opts = gitsigns.opts
	},
}

return M
