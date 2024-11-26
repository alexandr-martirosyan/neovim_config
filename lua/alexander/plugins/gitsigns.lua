local gitsigns = require "alexander.configs.plugins.gitsigns"

local M = {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		opts = gitsigns.opts
	},
}

return M
